//
//  HYDatabase.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/25.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookInfoModel.h"
#import "BookChapterTextModel.h"
#import "BookChapterModel.h"
#import "BookRecordModel.h"
#import "BookInfoModel.h"
#import "BookSaveInfoModel.h"
@interface HYDatabase : NSObject

+ (instancetype)sharedDatabase;

/* 书本记录*/
- (BOOL)saveBookInfoWithModel:(BookInfoModel*)model;
- (NSArray<BookInfoModel*>*)selectBookInfos;
- (BookInfoModel*)selectBookInfoWithRelatedId:(NSString*)relatedId;
- (void)deleteBookInfoWithRelatedId:(NSString*)relatedId;
- (BOOL)updateBookSourceWithRelatedId:(NSString*)relatedId Name:(NSString*)name SourceUrl:(NSString*)sourceUrl;

/* 阅读记录*/
- (BOOL)saveRecordWithChapterModel:(BookRecordModel*)model;
- (BookRecordModel*)selectBookRecordWithBookId:(NSString*)bookId;
- (void)deleteBookRecordWithBookId:(NSString*)bookId;

/* 章节信息*/
- (BOOL)saveChapterWithModel:(BookChapterModel*)model;
- (void)saveChaptersWithModelArray:(NSArray<BookChapterModel*>*)modelArr;
- (NSArray<BookChapterModel*>*)selectChapterWithSourceUrl:(NSString*)url;
- (NSArray<BookChapterModel*>*)testSelectAllChapter;

/* 章节内容*/
- (BOOL)saveChapterTextWithModel:(BookChapterTextModel*)model;
- (BookChapterTextModel*)selectChapterTextWithUrl:(NSString*)url;
- (BOOL)deleteChapterTextWithUrl:(NSString*)url;
- (BOOL)deleteChapterTextWithBookId:(NSString*)bookid;

/* 搜索历史*/
- (BOOL)saveSearchHistoryWithName:(NSString*)name;
- (NSArray<NSString*>*)selectSearchHistorys;
- (BOOL)deleteSearchWithName:(NSString*)name;
- (void)deleteAllSearch;

/* 查找用于主页显示的booksavemodel*/
- (NSArray<BookSaveInfoModel*>*)selectSaveBookInfos;
- (BOOL)deleteSaveBookInfoWith:(BookSaveInfoModel*)model;


- (instancetype)init __attribute__((unavailable("请使用sharedDatabase,以保证该类为单例")));
+ (instancetype)new __attribute__((unavailable("请使用sharedDatabase,以保证该类为单例")));

@end
