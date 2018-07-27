//
//  BookSearchListVC.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/29.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "HYBaseViewController.h"

/* 展示搜索结果的页面*/
@interface BookSearchListVC : HYBaseViewController

/* 根据书名关键字进行搜索*/
- (instancetype)initWithKeyWord:(NSString*)kw;

/* 根据分类名称进行搜索*/
- (instancetype)initWithSortName:(NSString*)sort;

/* 根据作者名称进行搜索*/
- (instancetype)initWithAuthorName:(NSString*)author;


@end
