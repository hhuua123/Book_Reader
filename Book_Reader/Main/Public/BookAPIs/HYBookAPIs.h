//
//  HYBookAPIs.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/25.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookInfoModel.h"
#import "BookChapterModel.h"
#import "BookChapterTextModel.h"
#import "BooksourceModel.h"

typedef void (^BookInfosSuccess)(NSArray<BookInfoModel*>* books);
typedef void (^BookRandomSuccess)(BookInfoModel* book);
typedef void (^BookChapterSuccess)(NSArray<BookChapterModel*>* chapters);
typedef void (^BookChapterTextSuccess)(BookChapterTextModel* chapterText);
typedef void (^BookNameSuccess)(NSArray<NSDictionary*>* names);
typedef void (^BookSourceSuccess)(NSArray<BooksourceModel*>* models);
typedef void (^BookSortSuccess)(NSArray<NSDictionary*>* array);

typedef void (^Fail)(NSError* err);
@interface HYBookAPIs : NSObject

/**
 * 根据书名搜索书本信息
 */
- (void)searchBookWithKeyWord:(NSString*)kw
                        Start:(NSInteger)start
                      Success:(BookInfosSuccess)success
                         Fail:(Fail)fail;


/**
 * 根据作者名搜索书本信息
 */
- (void)searchBookWithAuthor:(NSString*)author
                        Start:(NSInteger)start
                      Success:(BookInfosSuccess)success
                         Fail:(Fail)fail;

/**
 * 根据分类名称进行搜索
 */
- (void)searchBookWithSortName:(NSString*)sortName
                         Start:(NSInteger)start
                       Success:(BookInfosSuccess)success
                          Fail:(Fail)fail;


/**
 * 搜索书本分类
 * map k-v:
 * book_sort: 分类名
 * sort_count: 分类书本数量
 */
- (void)searchBookSortWithSuccess:(BookSortSuccess)success
                             Fail:(Fail)fail;


/**
 * 随机获取一本书
 */
- (void)randomSearchBookInfoWithSuccess:(BookRandomSuccess)success
                                   Fail:(Fail)fail;

/**
 * 获取书本目录
 */
- (void)chapterListWithBook:(BookInfoModel*)book
                    Success:(BookChapterSuccess)success
                       Fail:(Fail)fail;

/**
 * 获取章节内容
 */
- (void)chapterTextWithChapter:(BookChapterModel*)chapter
                       Success:(BookChapterTextSuccess)success
                          Fail:(Fail)fail;

/**
 * 根据输入的关键字搜索书名
 */
- (void)searchBookNamesWithKeyWord:(NSString*)kw
                           Success:(BookNameSuccess)success
                              Fail:(Fail)fail;


/**
 * 搜索热门小说名
 */
- (void)searchHotBookWithSuccess:(BookNameSuccess)success
                            Fail:(Fail)fail;


/**
 * 搜索书本书源
 */
- (void)searchBookSourceWithRelatedId:(NSString*)relatedId
                              Success:(BookSourceSuccess)success
                                 Fail:(Fail)fail;


/**
 * 根据rela_id查找书本信息
 */
- (void)searchBookInfoWithRela_id:(NSString*)rela_id
                          Success:(BookRandomSuccess)success
                             Fail:(Fail)fail;


/**
 * 预加载章节
 */
- (void)advanceLoadChapters:(NSArray<BookChapterModel*>*)chapters;

@end
