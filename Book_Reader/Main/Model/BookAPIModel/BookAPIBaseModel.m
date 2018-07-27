//
//  BookAPIBaseModel.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/25.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookAPIBaseModel.h"
#import <MJExtension/MJExtension.h>

@implementation BookAPIBaseModel

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if(self){
        [self mj_setKeyValues:dic];
    }
    return self;
}

@end
