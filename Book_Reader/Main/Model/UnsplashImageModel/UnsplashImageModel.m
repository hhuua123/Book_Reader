//
//  UnsplashImageModel.m
//  Book_Reader
//
//  Created by hhuua on 2019/3/4.
//  Copyright © 2019 hhuua. All rights reserved.
//

#import "UnsplashImageModel.h"
#import <MJExtension/MJExtension.h>

@implementation UnsplashImageModel
- (UnsplashImageModel*)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if(self){
        [self mj_setKeyValues:dic];
        self.imageId        = [dic objectForKey:@"id"];
        self.imgDescription = [dic objectForKey:@"description"];
    }
    return self;
}

@end
