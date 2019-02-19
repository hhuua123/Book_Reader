//
//  BookChapterTextModel.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/25.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookAPIBaseModel.h"

@interface BookChapterTextModel : BookAPIBaseModel

/* 章节的具体内容*/
@property (nonatomic,copy) NSString* info;
/* 章节的url*/
@property (nonatomic,copy) NSString* url;
/* 章节所属书本的book_id*/
@property (nonatomic,copy) NSString* book_id;

@end
