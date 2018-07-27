//
//  HYSwipeInteractiveTransition.h
//
//  Created by hhuua on 2017/8/21.
//  Copyright © 2017年 hhuua. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 用于在使用模态仿Navi动画时的渐进式返回动画
 */
@interface HYSwipeInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;
- (void)wireToViewController:(UIViewController*)viewController;

@end
