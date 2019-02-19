//
//  BookReadVC.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

//#import "HYBaseViewController.h"
#import <UIKit/UIKit.h>
#import "BookReadVMDelegate.h"

/* 阅读界面*/
@interface BookReadVC : UIViewController
/* ViewModel*/
@property (nonatomic,strong) id<BookReadVMDelegate> viewModel;


@end
