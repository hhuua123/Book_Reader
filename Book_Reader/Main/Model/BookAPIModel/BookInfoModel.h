//
//  BookInfoModel.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/25.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookAPIBaseModel.h"

@interface BookInfoModel : BookAPIBaseModel

/* 书本名称*/
@property (nonatomic,copy) NSString* book_name;
/* 作者*/
@property (nonatomic,copy) NSString* author;
/* 书本的关联id号码*/
@property (nonatomic,copy) NSString* related_id;
/* 书本更新时间(不太准)*/
@property (nonatomic,copy) NSString* update_time;
/* 书本简介*/
@property (nonatomic,copy) NSString* book_desc;
/* 书本图片url*/
@property (nonatomic,copy) NSString* book_image;
/* 当前所选书源的url*/
@property (nonatomic,copy) NSString* book_url;
/* 书本的书源名称*/
@property (nonatomic,copy) NSString* source_name;


/* 书本状态*/
@property (nonatomic,copy) NSString* book_state;
/* 书本分类*/
@property (nonatomic,copy) NSString* book_sort;
/* 书本最后章节*/
@property (nonatomic,copy) NSString* book_last_chapter;
/* 字数*/
@property (nonatomic,assign) NSInteger book_word_count;
/* 收藏人数*/
@property (nonatomic,assign) NSInteger collection_num;


@end
