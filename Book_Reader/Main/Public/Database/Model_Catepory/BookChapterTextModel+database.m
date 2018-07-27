//
//  BookChapterTextModel+database.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookChapterTextModel+database.h"
#import <objc/runtime.h>

#define kTimeKey @"ChapterTextModel_Time"
#define kDbIdKey @"ChapterTextModel_DbId"

@implementation BookChapterTextModel (database)

- (instancetype)initWithFMResult:(FMResultSet *)result
{
    self = [super init];
    if (self){
        self.url    = [result stringForColumn:@"chapter_url"];
        self.info   = [result stringForColumn:@"chapter_text"];
        self.dbId   = [result intForColumn:@"id"];
        self.time   = [result dateForColumn:@"time"];
    }
    return self;
}

#pragma mark - db
- (NSDate *)time
{
    if(objc_getAssociatedObject(self, kTimeKey) == nil){
        objc_setAssociatedObject(self, kTimeKey, [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, kTimeKey);
}

- (void)setTime:(NSDate *)time
{
    objc_setAssociatedObject(self, kTimeKey, time, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)dbId
{
    if(objc_getAssociatedObject(self, kDbIdKey) == nil){
        objc_setAssociatedObject(self, kDbIdKey, @(0), OBJC_ASSOCIATION_ASSIGN);
    }
    return [objc_getAssociatedObject(self, kDbIdKey) integerValue];
}

- (void)setDbId:(NSInteger)dbId
{
    objc_setAssociatedObject(self, kDbIdKey, @(dbId), OBJC_ASSOCIATION_ASSIGN);
}


@end
