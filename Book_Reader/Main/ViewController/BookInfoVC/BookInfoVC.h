//
//  BookInfoVC.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/29.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "HYBaseViewController.h"
#import "BookInfoModel.h"

/* 书本详情页面*/
@interface BookInfoVC : HYBaseViewController

- (instancetype)initWithModel:(BookInfoModel*)model;

/* 标记字段,当从作者列表跳转过来时,在点击作者名时返回而不是跳转*/
@property (nonatomic,copy) NSString* author;

@end
