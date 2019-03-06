//
//  AppDelegate.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/25.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "HYAppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "MainBookListVC.h"
#import "MainBookRightVC.h"
#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "UnsplashImageVC.h"

@interface HYAppDelegate ()

@end
@implementation HYAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UINavigationController *navi  = [[UINavigationController alloc] initWithRootViewController:[[MainBookListVC alloc] init]];
    MainBookRightVC* rightVC = [[MainBookRightVC alloc] init];

    MMDrawerController* drawerController = [[MMDrawerController alloc] initWithCenterViewController:navi rightDrawerViewController:rightVC];
    drawerController.maximumRightDrawerWidth = kScreenWidth * 0.8;
    drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = drawerController;
    [self.window makeKeyAndVisible];

    [self configureBoardManager];
    
    return YES;
}

#pragma mark 键盘收回管理
-(void)configureBoardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.keyboardDistanceFromTextField=60;
    manager.enableAutoToolbar = NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
