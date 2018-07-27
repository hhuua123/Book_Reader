//
//  HYHTTPSessionManager.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/25.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "HYHTTPSessionManager.h"

@implementation HYHTTPSessionManager

+ (instancetype)manager
{
    HYHTTPSessionManager* manager = [super manager];
    manager.requestSerializer = [AFHTTPRequestSerializer new];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    

    return manager;
}

@end
