//
//  UIView+HYEmptyView.h
//
//  Created by hhuua on 2017/8/10.
//  Copyright © 2017年 hhuua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYEmptyView.h"

@interface UIView (HYEmptyView)

/**
 * 空界面
 */
@property (nonatomic,strong) HYEmptyView* emptyView;

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
 * 不要刷新按钮的空数据界面
 */
- (void)changeEmptyViewToNoDataWithoutNoBtn;

/**
 * 切换到信息不完整界面
 */
- (void)changeEmptyViewToNoUserWith:(refreshBtnClick)target;

/**
 * 切换到施工中界面
 */
- (void)changeEmptyViewToBuild;

@end
