//
//  HYDatabase.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/25.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "HYDatabase.h"
#import <FMDB/FMDB.h>
#import "HYDatabaseMacros.h"
#import "NSDate+Utils.h"

#import "BookInfoModel+database.h"
#import "BookChapterTextModel+database.h"
#import "BookChapterModel+database.h"
#import "BookRecordModel+database.h"
#import "BookSaveInfoModel+database.h"

@interface HYDatabase()
@property (nonatomic,strong) FMDatabaseQueue* databaseQueue;
@property (nonatomic,strong) FMDatabase* database;
@end
@implementation HYDatabase

+ (instancetype)sharedDatabase
{
    static HYDatabase* database;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        database = [[HYDatabase alloc] initDataBase];
    });
    return database;
}

- (instancetype)initDataBase
{
    self = [super init];
    if(self){
        self.database       = [FMDatabase databaseWithPath:kHYDatabasePath];
        self.databaseQueue  = [FMDatabaseQueue databaseQueueWithPath:kHYDatabasePath];
        if([self.database open]){
            BOOL creat = [self.database executeUpdate:kHYDBCreateChapterTextTable];
            if(!creat){
                HYDebugLog(@"creat ChapterText Table error:%@",[self.database lastErrorMessage]);
            }
            creat = [self.database executeUpdate:kHYDBCreateChapterTable];
            if(!creat){
                HYDebugLog(@"creat Chapter Table error:%@",[self.database lastErrorMessage]);
            }
            creat = [self.database executeUpdate:kHYDBCreateRecordTable];
            if(!creat){
                HYDebugLog(@"creat Record Table error:%@",[self.database lastErrorMessage]);
            }
            creat = [self.database executeUpdate:kHYDBCreateSearchHistoryTabel];
            if(!creat){
                HYDebugLog(@"creat SearchHistory Table error:%@",[self.database lastErrorMessage]);
            }
            creat = [self.database executeUpdate:kHYDBCreateBookInfoTabel];
            if (!creat){
                HYDebugLog(@"creat BookInfo Tabel error:%@",[self.database lastErrorMessage]);
            }
            
            [self addTableColumn];
        }else{
            HYDebugLog(@"open database error!!");
        }
    }
    return self;
}

- (void)addTableColumn
{
    if(![self.database columnExists:@"user_select_time" inTableWithName:@"t_book_info"]){
        NSString* sql = @"alter table t_book_info add user_select_time DATETIME";
        BOOL success = [self.database executeUpdate:sql];
        if(!success){
            HYDebugLog(@"add column 'user_select_time' for table 't_book_info' error:%@",[self.database lastErrorMessage]);
        }
    }
    
    if (![self.database columnExists:@"book_id" inTableWithName:@"t_chapter_text"]){
        NSString* sql = @"alter table t_chapter_text add book_id TEXT";
        BOOL success = [self.database executeUpdate:sql];
        if (!success){
            HYDebugLog(@"add colume 'book_id' for table 't_chapter_text' error:%@",[self.database lastErrorMessage]);
        }
    }
}

#pragma mark - 章节内容
- (BOOL)saveChapterTextWithModel:(BookChapterTextModel*)model
{
    if (kStringIsEmpty(model.info) || kStringIsEmpty(model.url))
        return NO;
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            BOOL insert = [db executeUpdate:kHYDBInsertChapterText(model.url,model.info,[NSDate date], model.book_id)];
            if(!insert){
                HYDebugLog(@"insert BookChapterTextModel url = %@ error:%@",model.url,[db lastErrorMessage]);
            }
        }
        [db close];
    }];
    
    return YES;
}

- (BookChapterTextModel *)selectChapterTextWithUrl:(NSString *)url
{
    FMResultSet* result = [self.database executeQuery:kHYDBSelectChapterTextWithUrl(url)];
    
    if ([result next]){
        BookChapterTextModel* model = [[BookChapterTextModel alloc] initWithFMResult:result];
        [result close];
        return model;
    }
    
    return nil;
}

- (BOOL)deleteChapterTextWithUrl:(NSString*)url
{
    if (kStringIsEmpty(url))
        return NO;
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            BOOL del = [db executeUpdate:kHYDBDeleteChapterTextWithUrl(url)];
            if (!del){
                HYDebugLog(@"delete chapter_text where url = %@ error:%@",url,[db lastErrorMessage]);
            }
        }
        [db close];
    }];
    
    return YES;
}

- (BOOL)deleteChapterTextWithBookId:(NSString*)bookid
{
    if (kStringIsEmpty(bookid))
        return NO;
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            BOOL del = [db executeUpdate:kHYDBDeleteChapterTextWithBookId(bookid)];
            if (!del){
                HYDebugLog(@"delete chapter_text where book_id = %@ error:%@",bookid,[db lastErrorMessage]);
            }
        }
        [db close];
    }];
    
    return YES;
}

#pragma mark - 章节
- (void)saveChaptersWithModelArray:(NSArray<BookChapterModel*>*)modelArr
{
    kDISPATCH_ON_GLOBAL_QUEUE_HIGH(^(){
        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            if ([db open]){
                
                [db beginTransaction];
                BOOL isRollBack = NO;
                @try {
                    for (BookChapterModel* model in modelArr) {
                        [db executeUpdate:kHYDBInsertChapter(model.name, model.chapter_url, model.book_id, model.chapter_id, model.source_url, [NSDate date])];
                    }
                } @catch (NSException *exception) {
                    isRollBack = YES;
                    [db rollback];
                } @finally {
                    if (!isRollBack) {
                        [db commit];
                    }
                }
                
            }
            [db close];
        }];
    });

}

- (BOOL)saveChapterWithModel:(BookChapterModel *)model
{
    if (kStringIsEmpty(model.source_url)
        || kStringIsEmpty(model.chapter_url)
        || kStringIsEmpty(model.name)
        || kStringIsEmpty(model.chapter_id)){
        HYDebugLog(@"章节信息保存错误:%@",model);
        return NO;
    }
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL insert = [db executeUpdate:kHYDBInsertChapter(model.name, model.chapter_url, model.book_id, model.chapter_id, model.source_url, [NSDate date])];
        if(!insert){
            HYDebugLog(@"insert BookChapterModel name = %@ error:%@",model.name,[db lastErrorMessage]);
        }
    }];
    
    return YES;
}

- (NSArray<BookChapterModel*>*)selectChapterWithSourceUrl:(NSString*)url
{
    FMResultSet* result = [self.database executeQuery:kHYDBSelectChaptersWithSource_url(url)];
    
    NSMutableArray* dataArr = [NSMutableArray array];
    
    while ([result next]) {
        BookChapterModel* model = [[BookChapterModel alloc] initWithFMResult:result];
        if (model){
            [dataArr addObject:model];
        }
    }
    [result close];
    return dataArr;
}

- (void)deleteAllChapterWithSourceUrl:(NSString*)url
{
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            BOOL delete = [db executeUpdate:kHYDBDeleteChapterWithSource_url(url)];
            if (!delete){
                HYDebugLog(@"delete BookChapterModel where url = %@,error:%@!",url,[db lastErrorMessage]);
            }
        }
        [db close];
    }];
}

- (NSArray<BookChapterModel *> *)testSelectAllChapter
{
    FMResultSet* result = [self.database executeQuery:kHYDBSelectAllChapters];
    
    NSMutableArray* dataArr = [NSMutableArray array];
    
    while ([result next]) {
        BookChapterModel* model = [[BookChapterModel alloc] initWithFMResult:result];
        if (model){
            [dataArr addObject:model];
        }
    }
    [result close];
    return dataArr;
}

#pragma mark - 记录
- (BOOL)saveRecordWithChapterModel:(BookRecordModel *)model
{
    if (kStringIsEmpty(model.book_id) || kStringIsEmpty(model.record_text)){
        return NO;
    }
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            BOOL insert = [db executeUpdate:kHYDBInsertRecord(model.book_id,@(model.chapter_index),model.record_text,[NSDate date], model.chapter_name)];
            
            insert = [db executeUpdate:kHYDBUpdateBookUserTime([NSDate date], model.book_id)];
            
            if(!insert){
                HYDebugLog(@"insert BookRecordModel book_id = %@ error:%@",model.book_id,[db lastErrorMessage]);
            }
        }
        [db close];
    }];
    
    return YES;
}

- (BookRecordModel*)selectBookRecordWithBookId:(NSString*)bookId
{
    
    FMResultSet* result = [self.database executeQuery:kHYDBSelectRecordWithBook_id(bookId)];
    
    if ([result next]){
        BookRecordModel* model = [[BookRecordModel alloc] initWithFMResult:result];
        [result close];
        if (model){
            return model;
        }
    }
    return nil;
}

- (void)deleteBookRecordWithBookId:(NSString*)bookId
{
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            BOOL dele = [db executeUpdate:kHYDBDeleteRecordWithBook_id(bookId)];
            if (!dele){
                HYDebugLog(@"delete BookRecordModel bookid = %@ error:%@",bookId,[db lastErrorMessage]);
            }
        }
        [db close];
    }];
}

#pragma mark - 书本
- (BOOL)saveBookInfoWithModel:(BookInfoModel*)model
{
    if (!model){
        return NO;
    }
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            BOOL insert = [db executeUpdate:kHYDBInsertBookInfo(model.book_name, model.author, model.related_id, model.update_time, model.book_desc, model.book_image, model.book_url, model.source_name, model.book_state, model.book_sort, model.book_last_chapter, @(model.book_word_count), @(model.collection_num), [NSDate date], [NSDate date])];
            if(!insert){
                HYDebugLog(@"insert BookInfoModel book_name = %@ error:%@",model.book_name,[db lastErrorMessage]);
            }
        }
        [db close];
    }];
    
    return YES;
}

- (NSArray<BookInfoModel*>*)selectBookInfos
{
    FMResultSet* result = [self.database executeQuery:kHYDBSelectBookInfo];
    
    NSMutableArray* array = [NSMutableArray array];
    while ([result next]) {
        BookInfoModel* model = [[BookInfoModel alloc] initWithFMResult:result];
        if (model){
            [array addObject:model];
        }
    }
    [result close];
    return array;
}

- (BookInfoModel*)selectBookInfoWithRelatedId:(NSString*)relatedId
{
    FMResultSet* result = [self.database executeQuery:kHYDBSelectBookInfoWithRelatedId(relatedId)];
    
    if ([result next]){
        BookInfoModel* model = [[BookInfoModel alloc] initWithFMResult:result];
        [result close];
        return model;
    }
    return nil;
}

- (void)deleteBookInfoWithRelatedId:(NSString*)relatedId
{
    if (kStringIsEmpty(relatedId)){
        return;
    }
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            BOOL delete = [db executeUpdate:kHYDBDeleteBookInfo(relatedId)];
            if (!delete){
                HYDebugLog(@"delete BookInfoModel relatedId = %@ error:%@",relatedId, [db lastErrorMessage]);
            }
        }
        
        [db close];
    }];
}

- (BOOL)updateBookInfoUserTimeWithRelatedId:(NSString*)relatedId
{
    if (kStringIsEmpty(relatedId)){
        return NO;
    }
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            BOOL update = [db executeUpdate:kHYDBUpdateBookUserTime([NSDate date], relatedId)];
            if (!update){
                HYDebugLog(@"update BookInfoUserTime relatedId = %@ error:%@",relatedId, [db lastErrorMessage]);
            }
        }
        
        [db close];
    }];
    
    return YES;
}

- (BOOL)updateBookSourceWithRelatedId:(NSString*)relatedId Name:(NSString*)name SourceUrl:(NSString*)sourceUrl
{
    if (kStringIsEmpty(name) || kStringIsEmpty(sourceUrl)){
        return NO;
    }
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            BOOL update = [db executeUpdate:kHYDBUpdateBookSource(relatedId, name, sourceUrl)];
            if (!update){
                HYDebugLog(@"update BookSource relatedId = %@ error:%@",relatedId, [db lastErrorMessage]);
            }
        }
        
        [db close];
    }];
    
    return YES;
}

#pragma mark - 搜索历史
- (BOOL)saveSearchHistoryWithName:(NSString*)name
{
    if (kStringIsEmpty(name))
        return NO;
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            BOOL insert = [db executeUpdate:kHYDBInsertSearchHistory(name, [NSDate date])];
            if (!insert){
                HYDebugLog(@"insert SearchHistory name = %@ error:%@",name,[db lastErrorMessage]);
            }
        }
        [db close];
    }];
    
    return YES;
}

- (NSArray<NSString*>*)selectSearchHistorys
{
    FMResultSet* result = [self.database executeQuery:kHYDBSelectSearchHistory];
    
    NSMutableArray* arr = [NSMutableArray array];
    
    while ([result next]) {
        [arr addObject:[result stringForColumn:@"book_name"]];
    }
    
    [result close];
    return arr;
}

- (BOOL)deleteSearchWithName:(NSString*)name
{
    if (kStringIsEmpty(name))
        return NO;
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            BOOL dele = [db executeUpdate:kHYDBDeleteSearchHistoryWithName(name)];
            if (!dele){
                HYDebugLog(@"delete SearchHistory name = %@ error:%@",name,[db lastErrorMessage]);
            }
        }
        [db close];
    }];
    
    return YES;
}

- (void)deleteAllSearch
{
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            [db executeUpdate:kHYDBDeleteAllHistory];
        }
        [db close];
    }];
}

#pragma mark - 其他
- (NSArray<BookSaveInfoModel*>*)selectSaveBookInfos
{
    FMResultSet* result = [self.database executeQuery:kHYDBSelectBookInfosAndRecord];
    
    NSMutableArray* arr = [NSMutableArray array];
    while ([result next]) {
        BookSaveInfoModel* model = [[BookSaveInfoModel alloc] initWithFMResult:result];
        if (model){
            [arr addObject:model];
        }
    }
    return arr;
}

- (BOOL)deleteSaveBookInfoWith:(BookSaveInfoModel*)model;
{
    if (kStringIsEmpty(model.bookInfo.related_id)){
        return NO;
    }
    
    [self deleteBookInfoWithRelatedId:model.bookInfo.related_id];
    
    return YES;
}

@end
