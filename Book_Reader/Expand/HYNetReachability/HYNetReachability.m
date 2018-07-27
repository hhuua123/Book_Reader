//
//  HYNetReachability.m
//
//  Created by hhuua on 2017/6/12.
//  Copyright © 2017年 hhuua. All rights reserved.
//

#import "HYNetReachability.h"
#import "GCDMulticastDelegate.h"
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

@implementation HYNetReachability
{
    SCNetworkReachabilityRef _reachabilityRef;
    HYNetReachabilityStatus _currentStatus;
    NSMutableArray<NetReachabilityStatusChanged>* _blockArray;
    dispatch_queue_t HYNetReachabilityQueue;
    GCDMulticastDelegate<HYNetReachabilityDelegate>* multicastDelegate;
}

static void HYNetReachabilityCallBack(SCNetworkReachabilityRef target,SCNetworkReachabilityFlags flags,void	*__nullable	info)
{
#pragma unused (target)
    
    if(info==NULL || ![(__bridge NSObject*) info isKindOfClass:[HYNetReachability class]]){
        return;
    }
    
    HYNetReachability* reachability = (__bridge HYNetReachability*)info;
    HYNetReachabilityStatus status = HYNetReachabilityStatusWithFlags(flags);
    [reachability releasingNoticesWith:status];
}

static HYNetReachabilityStatus HYNetReachabilityStatusWithFlags(SCNetworkReachabilityFlags flags)
{
    HYNetReachabilityStatus status = HYNetReachabilityStatusUnknown;
    /**
     * kSCNetworkReachabilityFlagsReachable: 目标主机已连接
     * kSCNetworkReachabilityFlagsConnectionRequired: WWAN可用,但没有激活,需要激活连接或VPN连接等(视为当前使用WIFI网络)
     * kSCNetworkReachabilityFlagsConnectionOnTraffic: 按需连接(视为使用流量)
     * kSCNetworkReachabilityFlagsInterventionRequired: 当前连接不需要用户干预
     * kSCNetworkReachabilityFlagsConnectionOnDemand: 按需连接(视为使用流量)
     * kSCNetworkReachabilityFlagsIsLocalAddress: 本地连接
     * kSCNetworkReachabilityFlagsIsWWAN: WIFI可用
     */
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
    
    if (isNetworkReachable == NO){
        status = HYNetReachabilityStatusNotReachable;
    }
    else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        status = HYNetReachabilityStatusReachableViaWWAN;
    }
    else{
        status = HYNetReachabilityStatusReachableViaWiFi;
    }
    
    return status;
}

#pragma mark -- init
- (instancetype)init
{
    self = [super init];
    if(self){
        _blockArray             = [NSMutableArray array];
        HYNetReachabilityQueue  = dispatch_get_main_queue();
        multicastDelegate       = (GCDMulticastDelegate<HYNetReachabilityDelegate>*)[[GCDMulticastDelegate alloc] init];
    }
    
    return self;
}

+ (HYNetReachability*)sharedNewReachability
{
    static HYNetReachability* NetReachability;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        struct sockaddr_in address;
        memset(&address, 0, sizeof(address));
        address.sin_len     = sizeof(address);
        address.sin_family  = AF_INET;
        NetReachability     = [HYNetReachability reachabilityWithAddress:&address];
    });
    return NetReachability;
}

+ (HYNetReachability*)reachabilityWithHostName:(NSString *)hostName
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
    
    HYNetReachability* netReachability = NULL;
    
    if (reachability != NULL){
        netReachability = [[HYNetReachability alloc] init];
        if (netReachability != NULL){
            netReachability->_reachabilityRef = reachability; 
        }
        else{
            CFRelease(reachability);
        }
    }
    return netReachability;
}

+ (HYNetReachability*)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)hostAddress);
    
    HYNetReachability* netReachability = NULL;
    
    if (reachability != NULL){
        netReachability = [[HYNetReachability alloc] init];
        if (netReachability != NULL){
            netReachability->_reachabilityRef = reachability;
        }
        else{
            CFRelease(reachability);
        }
    }
    return netReachability;
}

#pragma mark -- func
- (void)addTargetWithBlock:(NetReachabilityStatusChanged)block
{
    if(!block){
        return;
    }
    if(![_blockArray containsObject:block]){
        [_blockArray addObject:block];
    }
}

- (void)addDelegate:(id<HYNetReachabilityDelegate>)delegate
{
    [multicastDelegate addDelegate:delegate delegateQueue:HYNetReachabilityQueue];
}

- (void)removeDelegate:(id<HYNetReachabilityDelegate>)delegate
{
    [multicastDelegate removeDelegate:delegate];
}

- (HYNetReachabilityStatus)currentNetStatus
{
    return _currentStatus;
}

- (void)releasingNoticesWith:(HYNetReachabilityStatus)status
{
    _currentStatus = status;
    
    for (NetReachabilityStatusChanged block in _blockArray) {
        if(block){
            block(self,_currentStatus);
        }
    }
    
    [multicastDelegate HYNetReachability:self ReachabilityChange:status];
}

#pragma mark -- get
- (BOOL)isHostReachableWIFI
{
    return _currentStatus == HYNetReachabilityStatusReachableViaWiFi;
}

- (BOOL)isHostReachableWWAN
{
    return _currentStatus == HYNetReachabilityStatusReachableViaWWAN;
}

- (BOOL)isHostReachable
{
    return ([self isHostReachableWWAN] || [self isHostReachableWIFI]);
}

#pragma mark -- Notifier
- (BOOL)startMonitorNetReachability
{
    BOOL returnValue = NO;
    /**
     * version:创建一个 SCNetworkReachabilityContext 结构体时，需要调用 SCDynamicStore 的创建函数，而此创建函数会根据 version 来创建出不同的结构体，SCNetworkReachabilityContext 对应的 version 是 0;
     * info:用户指定的需要传递的数据快，下面两个 block（retain 和 release）的参数就是 info。如果 info 是一个 block 类型，需要调用下面定义的 retain 和 release 进行拷贝和释放;
     * retain:该 retain block 用于对上述 info 进行 retain（一般通过调用 Block_copy 宏 retain 一个 block 函数，即在堆空间新建或直接引用一个 block 拷贝），该值可以为 NULL;
     * release:该 release block 用于对 info 进行 release（一般通过调用 Block_release 宏 release 一个 block 函数，即将 block 从堆空间移除或移除相应引用），该值可以为 NULL;
     * copyDescription:提供 info 的描述，一般取为 NULL.
     */
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    if (SCNetworkReachabilitySetCallback(_reachabilityRef, HYNetReachabilityCallBack, &context)){
        // 通过SCNetworkReachabilityScheduleWithRunLoop将_reachabilityRef添加至Run Loop以监听
        if (SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)){
            returnValue = YES;
        }
    }
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityGetFlags(_reachabilityRef, &flags);
    _currentStatus = HYNetReachabilityStatusWithFlags(flags);
    
    return returnValue;
}

- (void)stopMonitorNetReachability
{
    if (_reachabilityRef != NULL){
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}

/**
 * 先停止监听,_reachabilityRe手动释放
 */
- (void)dealloc
{
    [self stopMonitorNetReachability];
    if (_reachabilityRef != NULL){
        CFRelease(_reachabilityRef);
    }
}



@end
