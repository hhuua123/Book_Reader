//
//  BookSaveInfoModel+database.m
//  Book_Reader
//
//  Created by hhuua on 2018/7/3.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookSaveInfoModel+database.h"

@implementation BookSaveInfoModel (database)

- (instancetype)initWithFMResult:(FMResultSet*)result
{
    self = [super init];
    if (self){
        self.bookInfo = [[BookInfoModel alloc] initWithFMResult:result];
        self.bookRecord = [[BookRecordModel alloc] initWithFMResult:result];
    }
    return self;
}

@end
