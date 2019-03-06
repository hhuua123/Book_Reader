//
//  MBProgressHUD+NJ.m
//  NJWisdomCard
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 Weconex. All rights reserved.
//

#import "MBProgressHUD+NJ.h"
#import <objc/runtime.h>

#define CHINESE_FONT_NAME  @"Heiti SC"
#define CHINESE_SYSTEM(x) [UIFont fontWithName:CHINESE_FONT_NAME size:x]

static dispatch_source_t show_t;
@implementation MBProgressHUD (NJ)

/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabel.text = text;
    hud.detailsLabel.font=CHINESE_SYSTEM(14);
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    CGFloat time = text.length/8;
    if(time<1){
        time = 1;
    }
    [hud hideAnimated:YES afterDelay:time];
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 *  @param view    显示信息的视图
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

+ (void)showImages:(UIImage*)images message:(NSString*)message toView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.frame = CGRectMake(0, 0, 150, 150);
    hud.center = [UIApplication sharedApplication].keyWindow.center;
    hud.detailsLabel.text = message;
    hud.detailsLabel.font=CHINESE_SYSTEM(14);
    
    UIImageView* imageV = [[UIImageView alloc] initWithImage:images];
    imageV.image = images;
    imageV.frame = CGRectMake(0, 0, 150, 150);
    imageV.animationRepeatCount = 0;
    [imageV startAnimating];
    // 设置图片
    hud.customView = imageV;
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    
}

/**
 *  显示错误信息
 *
 */
+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

/**
 *  显示错误信息
 *
 *  @param error 错误信息内容
 *  @param view  需要显示信息的视图
 */
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

/**
 *  显示错误信息
 *
 *  @param message 信息内容
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)showMessage:(NSString *)message delay:(NSTimeInterval)time
{
    UIView* view = [UIApplication sharedApplication].keyWindow;
    [self showMessage:message toView:view delay:time];
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view delay:(NSTimeInterval)time
{
    if (view.show_mbp_t)
        dispatch_source_cancel(view.show_mbp_t);
    
    view.show_mbp_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(view.show_mbp_t, dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 0);
    dispatch_source_set_event_handler(view.show_mbp_t, ^{
        [self showMessage:message toView:view];
    });
    
    dispatch_resume(view.show_mbp_t);
}

/**
 *  显示一些信息
 *
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    return [self showMessage:message toView:view hideAfter:30];
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view hideAfter:(float)hideTime
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabel.text = message;
    hud.detailsLabel.font=CHINESE_SYSTEM(14);
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:hideTime];
    
    return hud;
}

/**
 *  手动关闭MBProgressHUD
 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

/**
 *  手动关闭MBProgressHUD
 *
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    if (view.show_mbp_t)
        dispatch_source_cancel(view.show_mbp_t);
    
    [self hideHUDForView:view animated:YES];
}

@end

@implementation UIView(MBP)
static char* ShowMbpT = "UIViewShowMbpT";

- (void)setShow_mbp_t:(dispatch_source_t)show_mbp_t
{
    objc_setAssociatedObject(self, ShowMbpT, show_mbp_t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_source_t)show_mbp_t
{
    return objc_getAssociatedObject(self, ShowMbpT);
}

@end
