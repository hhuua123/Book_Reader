//
//  GVUserDefaults+HYUserDefaults.m
//
//  Created by hhuua on 2017/8/10.
//  Copyright © 2017年 hhuua. All rights reserved.
//

#import "GVUserDefaults+HYUserDefaults.h"

@implementation GVUserDefaults (HYUserDefaults)

@dynamic userPhoneNum;
@dynamic userName;
@dynamic userEmail;
@dynamic PageNaviDirection;
@dynamic PageTransitionStyle;
@dynamic PageNaviOrientation;
@dynamic userReadAttConfigData;
@dynamic isNightStyle;
@dynamic adLoadChapters;
@dynamic readInfoColor;
@dynamic readBrightness;
@dynamic readBackColorData;
@dynamic hotWordArr;

- (NSDictionary *)userReadAttConfig
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.userReadAttConfigData];
}

- (void)setUserReadAttConfig:(NSDictionary *)userReadAttConfig
{
    self.userReadAttConfigData = [NSKeyedArchiver archivedDataWithRootObject:userReadAttConfig];
}

- (UIColor *)readBackColor
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.readBackColorData];
}

- (void)setReadBackColor:(UIColor *)readBackColor
{
    self.readBackColorData = [NSKeyedArchiver archivedDataWithRootObject:readBackColor];
}

@end
