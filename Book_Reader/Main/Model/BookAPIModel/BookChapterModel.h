//
//  BookChapterModel.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/25.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookAPIBaseModel.h"

@interface BookChapterModel : BookAPIBaseModel

/* 章节名*/
@property (nonatomic,copy) NSString* name;
/* 章节url*/
@property (nonatomic,copy) NSString* chapter_url;
/* 书本的关联id*/
@property (nonatomic,copy) NSString* book_id;
/* 章节在书源处的id编号*/
@property (nonatomic,copy) NSString* chapter_id;
/* 章节来源的url*/
@property (nonatomic,copy) NSString* source_url;


@end
