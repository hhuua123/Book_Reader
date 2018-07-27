//
//  BookRecordModel.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookRecordModel.h"

@implementation BookRecordModel

- (instancetype)initWithId:(NSString*)book_id
                     index:(NSInteger)index
                    record:(NSString*)record
               chapterName:(NSString*)chapterName
{
    self = [super init];
    if (self){
        self.book_id = book_id;
        self.chapter_index = index;
        self.record_text = record;
        self.chapter_name = chapterName;
    }
    return self;
}

@end
