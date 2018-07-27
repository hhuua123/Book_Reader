//
//  BooksourceModel.h
//  Book_Reader
//
//  Created by hhuua on 2018/7/19.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookAPIBaseModel.h"

@interface BooksourceModel : BookAPIBaseModel

/* 关联id*/
@property (nonatomic,copy) NSString* related_id;
/* 更新时间*/
@property (nonatomic,copy) NSString* update_time;
/* 书源url*/
@property (nonatomic,copy) NSString* book_url;
/* 书源名称*/
@property (nonatomic,copy) NSString* source_name;
/* 最后章节*/
@property (nonatomic,copy) NSString* book_last_chapter;


@end
