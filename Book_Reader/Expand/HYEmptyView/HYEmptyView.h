//
//  HYEmptyView.h
//
//  Created by hhuua on 2017/6/19.
//  Copyright © 2017年 hhuua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYNetReachability.h"

#define WeakSelf(weakSelf) __weak __typeof(&*self) weakSelf  = self;
#define StrongSelf(strongSelf) __strong __typeof(&*self) strongSelf = weakSelf;

typedef void(^netStatusChange)(HYNetReachability* reachability,HYNetReachabilityStatus status);
typedef void(^refreshBtnClick)(void);

@interface HYEmptyView : UIView
@property (nonatomic,strong) HYNetReachability* reachability;

/**
 * 不加入网络状态监控
 */
- (instancetype)initWithSuperView:(UIView*)superView;

/**
 * @param superView             emptyView的父视图
 * @param netReachablity        是否加入网络状态监控
 * @param netBlock              网络状态改变回调
 */
- (instancetype)initWithSuperView:(UIView*)superView
               AutoNetReachablity:(BOOL)netReachablity
                  NetStatusChange:(netStatusChange)netBlock;

/**
 * 移除空界面
 */
- (void)removeEmptyView;

/**
 * 切换到网络错误状态页面
 */
- (void)changeEmptyViewToNetErrorWith:(refreshBtnClick)target;

/**
 * 切换到空数据界面
 */
- (void)changeEmptyViewToNoDataWith:(refreshBtnClick)target;

/**
 * 切换到信息不完整界面
 */
- (void)changeEmptyViewToNoUserWith:(refreshBtnClick)target;

/**
 * 切换到施工界面
 */
- (void)changeEmptyViewToBuild;

/**
 * 切换界面
 */
- (void)changeWithImage:(UIImage*)image
                   Info:(NSString*)info
               BtnTitle:(NSString*)btnTitle
                 Target:(refreshBtnClick)target;


@property (nonatomic,strong) UIImage* emptyImage;
@property (nonatomic,copy) NSString* refreshBtnTitle;
@property (nonatomic,copy) NSString* infoTitle;


@end
