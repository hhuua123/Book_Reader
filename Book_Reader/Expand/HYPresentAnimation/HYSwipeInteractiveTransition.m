//
//  HYSwipeInteractiveTransition.m
//
//  Created by hhuua on 2017/8/21.
//  Copyright © 2017年 hhuua. All rights reserved.
//

#import "HYSwipeInteractiveTransition.h"
#import "HYBaseViewController.h"

@interface HYSwipeInteractiveTransition()
@property (nonatomic, assign) BOOL shouldComplete;
@property (nonatomic, strong) UIViewController *presentingVC;
@end

@implementation HYSwipeInteractiveTransition

-(void)wireToViewController:(UIViewController *)viewController
{
    self.presentingVC = viewController;
    
    if([viewController isKindOfClass:[HYBaseViewController class]]){
        
        [self prepareGestureRecognizerInView:viewController.view];
    }else if ([viewController isKindOfClass:[UINavigationController class]]){
        
        UINavigationController* navi = (UINavigationController*)viewController;
        if ([navi.topViewController isKindOfClass:[HYBaseViewController class]]){
            [self prepareGestureRecognizerInView:viewController.view];
        }
    }
}

- (void)prepareGestureRecognizerInView:(UIView*)view {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
}

-(CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            
            if(translation.x<0.4){
                self.interacting = YES;
                [self.presentingVC dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        case UIGestureRecognizerStateChanged: {
            
            CGFloat fraction = translation.x / (kScreenWidth*0.7);
            
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            self.shouldComplete = (fraction > 0.5);
            
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            
            self.interacting = NO;
            if (!self.shouldComplete || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

@end
