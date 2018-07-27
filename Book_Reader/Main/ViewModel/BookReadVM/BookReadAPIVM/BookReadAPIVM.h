//
//  BookReadAPIVM.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookReadVMDelegate.h"
#import "BookInfoModel.h"

/* 网络接口API书源ViewModel*/
@interface BookReadAPIVM : NSObject<BookReadVMDelegate>

/* 从书本model初始化*/
- (instancetype)initWithBookModel:(BookInfoModel*)model;
@property (nonatomic,strong,readonly) BookInfoModel* model;


@end
