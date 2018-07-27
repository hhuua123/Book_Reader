//
//  HYBaseViewController.h
//
//  Created by hhuua on 2017/8/10.
//  Copyright © 2017年 hhuua. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HYBaseViewController : UIViewController
@property (nonatomic, assign, getter=isFirstLoad) BOOL firstLoad;

/**
 * 模态推出并使用Navi的push和pop动画
 */
- (void)pushPresentViewController:(UIViewController *)viewControllerToPresent;
- (void)pushPresentWithOutSwipeViewController:(UIViewController *)viewControllerToPresent;

@end
