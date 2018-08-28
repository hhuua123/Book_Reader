//
//  BookSourceListVC.h
//  Book_Reader
//
//  Created by hhuua on 2018/7/23.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "HYBaseViewController.h"
#import "BookInfoModel.h"

/* 书源选择列表界面*/
typedef void (^selectSource)(void);
@interface BookSourceListVC : HYBaseViewController


@property (nonatomic, strong) BookInfoModel* mode;
- (instancetype)initWithModel:(BookInfoModel*)model;

@property (nonatomic,strong) selectSource block;

@end
