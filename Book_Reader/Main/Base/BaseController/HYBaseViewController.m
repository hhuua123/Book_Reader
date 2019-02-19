//
//  HYBaseViewController.m
//
//  Created by hhuua on 2017/8/10.
//  Copyright © 2017年 hhuua. All rights reserved.
//

#import "HYBaseViewController.h"
#import "HYPresentPushAnimation.h"
#import "HYDismissPopAnimation.h"
#import "HYSwipeInteractiveTransition.h"

@interface HYBaseViewController ()<UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) HYPresentPushAnimation *presentAnimation;
@property (nonatomic, strong) HYDismissPopAnimation *dismissAnimation;
@property (nonatomic, strong) HYSwipeInteractiveTransition *transitionController;

@end

@implementation HYBaseViewController

- (instancetype)init
{
    self = [super init];
    if(self){
        _presentAnimation     = [HYPresentPushAnimation new];
        _dismissAnimation     = [HYDismissPopAnimation new];
        _transitionController = [HYSwipeInteractiveTransition new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - navi返回动画
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _firstLoad = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    [self.view endEditing:YES];
}

- (void)pushPresentViewController:(UIViewController *)viewControllerToPresent
{
    viewControllerToPresent.transitioningDelegate = self;
    [self.transitionController wireToViewController:viewControllerToPresent];
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}

- (void)pushPresentWithOutSwipeViewController:(UIViewController *)viewControllerToPresent;
{
    viewControllerToPresent.transitioningDelegate = self;
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.presentAnimation;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissAnimation;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.transitionController.interacting ? self.transitionController : nil;
}


@end
