//
//  HYNetReachability.h
//  yuanchengTravel
//
//  Created by 黄也 on 2017/6/12.
//  Copyright © 2017年 杭州通悟科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
/**
 * 在IOS8下,苹果提供的Reachability示例代码在从IPv4切换到IPv6网络，或者从IPv6网络切换到IPv4时不会
 * 提供网络状态改变的回调。IPV6问题只需要在苹果最新的版本中支持即可。
 */
@class HYNetReachability;
typedef NS_ENUM(NSInteger, TWNetReachabilityStatus) {
    TWNetReachabilityStatusUnknown              = -1,   //未识别的网络
    TWNetReachabilityStatusNotReachable         =  0,   //无法链接
    TWNetReachabilityStatusReachableViaWWAN     =  1,   //流量网络
    TWNetReachabilityStatusReachableViaWiFi     =  2,   //WiFi网络
};

typedef void (^NetReachabilityStatusChanged)(HYNetReachability* reachability,TWNetReachabilityStatus status);

@protocol TWNetReachabilityDelegate <NSObject>
@optional
/**
 * 网络状态改变
 */
- (void)TWNetReachability:(HYNetReachability*)reachability ReachabilityChange:(TWNetReachabilityStatus)status;

@end

#define kSharedTWNetReachability [TWNetReachability sharedNewReachability]
#define kSharedTWNetReachabilityStatus [kSharedTWNetReachability currentNetStatus]

@interface HYNetReachability : NSObject
/**
 * 通过将sockaddr_in创建为零地址:0.0.0.0,查询本机的网络连接状态
 */
+ (HYNetReachability*)sharedNewReachability;

/**
 * 通过指定的服务器IP地址(sockaddr_in参数)初始化
 */
+ (HYNetReachability*)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress;

/**
 * 通过指定的服务器域名初始化
 */
+ (HYNetReachability*)reachabilityWithHostName:(NSString *)hostName;

/**
 * 通过Block获取状态改变的回调
 */
- (void)addTargetWithBlock:(NetReachabilityStatusChanged)block;

/**
 * 添加代理
 */
- (void)addDelegate:(id<TWNetReachabilityDelegate>)delegate;

/**
 * 在对象被释放之前,移除代理
 */
- (void)removeDelegate:(id<TWNetReachabilityDelegate>)delegate;

/**
 * 开始监听网络
 */
- (BOOL)startMonitorNetReachability;

/**
 * 结束监听网络
 */
- (void)stopMonitorNetReachability;

/**
 * 获取当前状态
 */
- (TWNetReachabilityStatus)currentNetStatus;

/**
 * 当前网络是否可达
 */
@property (readonly,nonatomic,assign,getter=isHostReachable) BOOL hostReachable;

/**
 * 当前网络是否是WIFI网络
 */
@property (readonly,nonatomic,assign,getter=isHostReachableWIFI) BOOL hostReachableWIFI;

/**
 * 当前网络是否是流量网络
 */
@property (readonly,nonatomic,assign,getter=isHostReachableWWAN) BOOL hostReachableWWAN;

@end
