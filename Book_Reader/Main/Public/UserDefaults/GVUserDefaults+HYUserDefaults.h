//
//  GVUserDefaults+HYUserDefaults.h
//
//  Created by hhuua on 2017/8/10.
//  Copyright © 2017年 hhuua. All rights reserved.
//

#import "GVUserDefaults.h"

#define HYUserDefault [GVUserDefaults standardUserDefaults]

@interface GVUserDefaults (HYUserDefaults)

/* 用户手机号码*/
@property (nonatomic,copy) NSString* userPhoneNum;
/* 用户名*/
@property (nonatomic,copy) NSString* userName;
/* 邮箱*/
@property (nonatomic,copy) NSString* userEmail;

# pragma mark - 用户阅读配置信息
/* 预加载的章节数量*/
@property (nonatomic,assign) NSInteger adLoadChapters;
/* 用户阅读的富文本设置(字号,间距,颜色等信息)*/
@property (nonatomic,strong) NSDictionary* userReadAttConfig;
@property (nonatomic,strong) NSData* userReadAttConfigData;
/* 阅读器的翻页方向(右<->左 下<->上)*/
@property (nonatomic,assign) enum UIPageViewControllerNavigationDirection PageNaviDirection;
/* 翻页方式(页面卷曲 滚动)*/
@property (nonatomic,assign) enum UIPageViewControllerTransitionStyle PageTransitionStyle;

@property (nonatomic,assign) enum UIPageViewControllerNavigationOrientation PageNaviOrientation;
/* 阅读界面背景颜色*/
@property (nonatomic,strong) UIColor* readBackColor;
@property (nonatomic,strong) NSData* readBackColorData;
/* 阅读界面章节等附属信息颜色*/
@property (nonatomic,strong) UIColor* readInfoColor;
/* 是否是夜间模式*/
@property (nonatomic,assign) BOOL isNightStyle;
/* 阅读界面亮度*/
@property (nonatomic,assign) float readBrightness;


#pragma mark - 借助userDeaults缓存部分轻量信息
/* 搜索热词*/
@property (nonatomic,strong) NSArray* hotWordArr;


@end
