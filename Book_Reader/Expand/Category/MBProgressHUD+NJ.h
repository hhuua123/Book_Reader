//
//  MBProgressHUD+NJ.h
//  NJWisdomCard
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 Weconex. All rights reserved.
//

#import "MBProgressHUD.h"

@interface UIView (MBP)

@property (strong, nonatomic) dispatch_source_t show_mbp_t;

@end

@interface MBProgressHUD (NJ)

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message delay:(NSTimeInterval)time;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
+ (void)showMessage:(NSString *)message toView:(UIView *)view delay:(NSTimeInterval)time;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view hideAfter:(float)hideTime;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

//显示一个GIF图片数组
+ (void)showImages:(UIImage*)images message:(NSString*)message toView:(UIView *)view;

@end
