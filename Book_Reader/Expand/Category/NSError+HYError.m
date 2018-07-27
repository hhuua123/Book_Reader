//
//  NSError+HYError.m
//
//  Created by hhuua on 2018/3/22.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "NSError+HYError.h"

@implementation NSError (HYError)

+ (instancetype)errorWithDescription:(NSString*)description
{
    return [self errorWithCode:9999 Description:description];
}

+ (instancetype)errorWithCode:(NSInteger)code Description:(NSString*)description
{
    NSError* err = [[NSError alloc]
                    initWithDomain:NSCocoaErrorDomain
                    code:code
                    userInfo:@{
                               NSLocalizedDescriptionKey : description,
                               }];
    return err;
}

@end
