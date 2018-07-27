//
//  BookInfoModel+database.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookInfoModel+database.h"

@implementation BookInfoModel (database)

- (instancetype)initWithFMResult:(FMResultSet *)result
{
    self = [super init];
    if (self){
        self.book_name              = [result stringForColumn:@"book_name"];
        self.author                 = [result stringForColumn:@"author"];
        self.related_id             = [result stringForColumn:@"related_id"];
        self.update_time            = [result stringForColumn:@"update_time"];
        self.book_desc              = [result stringForColumn:@"book_desc"];
        self.book_image             = [result stringForColumn:@"book_image"];
        self.book_url               = [result stringForColumn:@"book_url"];
        self.source_name            = [result stringForColumn:@"source_name"];
        self.book_state             = [result stringForColumn:@"book_state"];
        self.book_sort              = [result stringForColumn:@"book_sort"];
        self.book_last_chapter      = [result stringForColumn:@"book_last_chapter"];
        self.book_word_count        = [result intForColumn:@"book_word_count"];
        self.collection_num         = [result intForColumn:@"collection_num"];
    }
    return self;
}

@end
