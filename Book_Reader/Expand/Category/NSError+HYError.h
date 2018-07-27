//
//  NSError+HYError.h
//
//  Created by hhuua on 2018/3/22.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (HYError)

+ (instancetype)errorWithCode:(NSInteger)code Description:(NSString*)description;
+ (instancetype)errorWithDescription:(NSString*)description;

@end
