//
//  BookRecordModel+database.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookRecordModel+database.h"

@implementation BookRecordModel (database)

- (instancetype)initWithFMResult:(FMResultSet *)result
{
    self = [super init];
    if (self) {
        self.book_id        = [result stringForColumn:@"book_id"];
        self.chapter_index  = [result intForColumn:@"chapter_index"];
        self.record_text    = [result stringForColumn:@"record_text"];
        self.chapter_name   = [result stringForColumn:@"chapter_name"];
        self.record_time    = [result objectForColumn:@"record_time"];
    }
    return self;
}

@end
