//
//  BookChapterModel+database.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookChapterModel+database.h"

@implementation BookChapterModel (database)

- (instancetype)initWithFMResult:(FMResultSet *)result
{
    self = [super init];
    if (self){
        self.name           = [result stringForColumn:@"chapter_name"];
        self.chapter_url    = [result stringForColumn:@"chapter_url"];
        self.book_id        = [result stringForColumn:@"book_id"];
        self.chapter_id     = [result stringForColumn:@"chapter_id"];
        self.source_url     = [result stringForColumn:@"source_url"];
    }
    return self;
}

@end
