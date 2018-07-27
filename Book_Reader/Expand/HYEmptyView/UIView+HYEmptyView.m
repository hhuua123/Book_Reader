//
//  UIView+HYEmptyView.m
//
//  Created by hhuua on 2017/8/10.
//  Copyright © 2017年 hhuua. All rights reserved.
//

#import "UIView+HYEmptyView.h"
#import <objc/runtime.h>
#import "UIView+HYView.h"

static char* HYEmptyViewKey = "HYEmptyViewKey";
@implementation UIView (HYEmptyView)


- (void)removeEmptyView
{
    [self.emptyView removeEmptyView];
}

- (void)changeEmptyViewToNetErrorWith:(refreshBtnClick)target
{
    [self.emptyView changeEmptyViewToNetErrorWith:target];
}

- (void)changeEmptyViewToNoDataWith:(refreshBtnClick)target
{
    [self.emptyView changeEmptyViewToNoDataWith:target];
}

- (void)changeEmptyViewToNoDataWithoutNoBtn
{
    [self.emptyView changeWithImage:[UIImage imageNamed:@"HYEmptyViewImage.bundle/empty_noData"]
                               Info:@"暂无通知信息"
                           BtnTitle:nil
                             Target:nil];
    self.emptyView.backgroundColor = UIHexColor(0xeeeeee);
}

- (void)changeEmptyViewToNoUserWith:(refreshBtnClick)target
{
    [self.emptyView changeEmptyViewToNoUserWith:target];
}

- (void)changeEmptyViewToBuild
{
    [self.emptyView changeEmptyViewToBuild];
}

- (void)setEmptyView:(HYEmptyView *)emptyView
{
    objc_setAssociatedObject(self, HYEmptyViewKey, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HYEmptyView *)emptyView
{
    if(objc_getAssociatedObject(self, HYEmptyViewKey) == nil){
        objc_setAssociatedObject(self, HYEmptyViewKey, [[HYEmptyView alloc] initWithSuperView:self], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return objc_getAssociatedObject(self, HYEmptyViewKey);
}

@end
