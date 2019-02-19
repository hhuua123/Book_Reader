//
//  HYBookAPIs.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/25.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "HYBookAPIs.h"
#import "HYHTTPSessionManager.h"
#import "NSError+HYError.h"
#import "HYDatabase.h"
#import "HYHigherOrderFunc.h"

NSString * const kSearchBookUrl             = @"http://api.hhuua.top:9000/bookApi/search?";
NSString * const kSearchBook_AuthorUrl      = @"http://api.hhuua.top:9000/bookApi/author?";
NSString * const kRandom_SearchBookUrl      = @"http://api.hhuua.top:9000/bookApi/random_book";
NSString * const kChapter_listUrl           = @"http://api.hhuua.top:9000/bookApi/chapter?";
NSString * const kChapter_TextUrl           = @"http://api.hhuua.top:9000/bookApi/chapter_text?";
NSString * const kBookName_SearchUrl        = @"http://api.hhuua.top:9000/bookApi/name_search?";
NSString * const kBookHot_SearchUrl         = @"http://api.hhuua.top:9000/bookApi/hot_word";
NSString * const kBookSource_SearchUrl      = @"http://api.hhuua.top:9000/bookApi/source?";
NSString * const kBookSort_SearchUrl        = @"http://api.hhuua.top:9000/bookApi/sort";
NSString * const kBookSearchBook_SortUrl    = @"http://api.hhuua.top:9000/bookApi/search/sort?";
NSString * const kBookInfoUrl               = @"http://api.hhuua.top:9000/bookApi/book_info?";


@interface HYBookAPIs()
@property (nonatomic, strong) HYDatabase* database;
@end
@implementation HYBookAPIs

- (instancetype)init
{
    self = [super init];
    if (self){
        self.database = [HYDatabase sharedDatabase];
    }
    return self;
}

- (void)searchBookWithKeyWord:(NSString*)kw
                        Start:(NSInteger)start
                      Success:(BookInfosSuccess)success
                         Fail:(Fail)fail
{
    HYHTTPSessionManager* manager = [HYHTTPSessionManager manager];
    
    NSDictionary* dic = @{
                          @"q": kw,
                          @"s": @(start),
                          };
    
    [manager GET:kSearchBookUrl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self analysisBookWithObj:responseObject Success:success Fail:fail];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail){
            fail(error);
        }
    }];
}

- (void)searchBookWithAuthor:(NSString*)author
                       Start:(NSInteger)start
                     Success:(BookInfosSuccess)success
                        Fail:(Fail)fail
{
    HYHTTPSessionManager* manager = [HYHTTPSessionManager manager];
    
    NSDictionary* dic = @{
                          @"author": author,
                          @"s": @(start),
                          };
    
    [manager GET:kSearchBook_AuthorUrl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self analysisBookWithObj:responseObject Success:success Fail:fail];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail){
            fail(error);
        }
    }];
}

- (void)randomSearchBookInfoWithSuccess:(BookRandomSuccess)success
                                   Fail:(Fail)fail
{
    HYHTTPSessionManager* manager = [HYHTTPSessionManager manager];
    
    [manager GET:kRandom_SearchBookUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary* dic = (NSDictionary*)responseObject;
            BookInfoModel* model = [[BookInfoModel alloc] initWithDic:dic];
            if (success){
                success(model);
            }
        }else{
            if (fail){
                fail([NSError errorWithDescription:@"responseObject 类型错误,与接口文档不符!"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail){
            fail(error);
        }
    }];
}

- (void)chapterListWithBook:(BookInfoModel*)book
                    Success:(BookChapterSuccess)success
                       Fail:(Fail)fail
{
    HYHTTPSessionManager* manager = [HYHTTPSessionManager manager];
    
    NSDictionary* dic = @{
                          @"url": book.book_url,
                          @"id": book.related_id,
                          };
    
    [manager GET:kChapter_listUrl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self analysisChapterListWithObj:responseObject Success:success Fail:fail];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail){
            fail(error);
        }
    }];
}

- (void)chapterTextWithChapter:(BookChapterModel*)chapter
                       Success:(BookChapterTextSuccess)success
                          Fail:(Fail)fail
{
    /* 查库*/
    BookChapterTextModel* db_model = [self.database selectChapterTextWithUrl:chapter.chapter_url];
    if (db_model){
        if (success){
            success(db_model);
        }
        return;
    }
    
    HYHTTPSessionManager* manager = [HYHTTPSessionManager manager];
    
    NSDictionary* dic = @{
                          @"url": chapter.chapter_url,
                          };
    
    [manager GET:kChapter_TextUrl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary* dic = (NSDictionary*)responseObject;
            BookChapterTextModel* model = [[BookChapterTextModel alloc] initWithDic:dic];
            model.book_id = chapter.book_id;
            
            if (success){
                success(model);
            }
            /* 存库*/
            [self.database saveChapterTextWithModel:model];
        }else{
            if (fail){
                fail([NSError errorWithDescription:@"responseObject 类型错误,与接口文档不符!"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail){
            fail(error);
        }
    }];
}

- (void)advanceLoadChapters:(NSArray<BookChapterModel*>*)chapters
{
    for (id obj in chapters) {
        if ([obj isKindOfClass:[BookChapterModel class]]){
            [self chapterTextWithChapter:obj Success:nil Fail:nil];
        }
    }
}

- (void)searchBookNamesWithKeyWord:(NSString*)kw
                           Success:(BookNameSuccess)success
                              Fail:(Fail)fail
{
    HYHTTPSessionManager* manager = [HYHTTPSessionManager manager];
    
    NSDictionary* dic = @{
                          @"q": kw,
                          };
    
    [manager GET:kBookName_SearchUrl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]){
            NSArray* arr = (NSArray*)responseObject;
            if (success){
                success(arr);
            }
        }else{
            if (fail){
                fail([NSError errorWithDescription:@"responseObject 类型错误,与接口文档不符!"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail){
            fail(error);
        }
    }];
}

- (void)searchHotBookWithSuccess:(BookNameSuccess)success
                              Fail:(Fail)fail
{
    HYHTTPSessionManager* manager = [HYHTTPSessionManager manager];
    
    [manager GET:kBookHot_SearchUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]){
            NSArray* arr = (NSArray*)responseObject;
            if (success){
                success(arr);
            }
        }else{
            if (fail){
                fail([NSError errorWithDescription:@"responseObject 类型错误,与接口文档不符!"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail){
            fail(error);
        }
    }];
}

- (void)searchBookSourceWithRelatedId:(NSString*)relatedId
                              Success:(BookSourceSuccess)success
                                 Fail:(Fail)fail
{
    HYHTTPSessionManager* manager = [HYHTTPSessionManager manager];
    
    NSDictionary* dic = @{
                          @"id": relatedId,
                          };
    
    [manager GET:kBookSource_SearchUrl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self analysisBookSourceWithObj:responseObject Success:success Fail:fail];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail){
            fail(error);
        }
    }];
}

- (void)searchBookSortWithSuccess:(BookSortSuccess)success
                             Fail:(Fail)fail
{
    HYHTTPSessionManager* manager = [HYHTTPSessionManager manager];
    
    [manager GET:kBookSort_SearchUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]){
            NSArray* arr = (NSArray*)responseObject;
            /* 过滤服务器有时返回的分类类型为空的情况*/
            arr = kFilter(arr, ^BOOL(NSDictionary* obj) {
                return !kStringIsEmpty((NSString*)[obj objectForKey:@"book_sort"]);
            });
            if (success){
                success(arr);
            }
        }else{
            if (fail){
                fail([NSError errorWithDescription:@"responseObject 类型错误,与接口文档不符!"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail){
            fail(error);
        }
    }];
}

- (void)searchBookWithSortName:(NSString*)sortName
                         Start:(NSInteger)start
                       Success:(BookInfosSuccess)success
                          Fail:(Fail)fail
{
    HYHTTPSessionManager* manager = [HYHTTPSessionManager manager];
    
    NSDictionary* dic = @{
                          @"sort": sortName,
                          @"s": @(start),
                          };
    
    [manager GET:kBookSearchBook_SortUrl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self analysisBookWithObj:responseObject Success:success Fail:fail];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail){
            fail(error);
        }
    }];
}

- (void)searchBookInfoWithRela_id:(NSString*)rela_id
                          Success:(BookRandomSuccess)success
                             Fail:(Fail)fail
{
    HYHTTPSessionManager* manager = [HYHTTPSessionManager manager];
    
    NSDictionary* dic = @{
                          @"id": rela_id,
                          };
    
    [manager GET:kBookInfoUrl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary* dic = (NSDictionary*)responseObject;
            BookInfoModel* model = [[BookInfoModel alloc] initWithDic:dic];
            if (success){
                success(model);
            }
        }else{
            if (fail){
                fail([NSError errorWithDescription:@"responseObject 类型错误,与接口文档不符!"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail){
            fail(error);
        }
    }];
}

#pragma mark - analysis
- (void)analysisBookSourceWithObj:(id  _Nullable)responseObject Success:(BookSourceSuccess)success Fail:(Fail)fail
{
    if ([responseObject isKindOfClass:[NSArray class]]){
        NSArray* data = (NSArray*)responseObject;
        NSMutableArray* models = [NSMutableArray array];
        for (NSDictionary* dic in data) {
            BooksourceModel* model = [[BooksourceModel alloc] initWithDic:dic];
            if(model){
                [models addObject:model];
            }
        }
        
        if (success){
            success(models);
        }
    }else{
        if (fail){
            fail([NSError errorWithDescription:@"responseObject 类型错误,与接口文档不符!"]);
        }
    }
}

- (void)analysisBookWithObj:(id  _Nullable)responseObject Success:(BookInfosSuccess)success Fail:(Fail)fail
{
    if ([responseObject isKindOfClass:[NSArray class]]){
        NSArray* data = (NSArray*)responseObject;
        NSMutableArray* models = [NSMutableArray array];
        for (NSDictionary* dic in data) {
            BookInfoModel* model = [[BookInfoModel alloc] initWithDic:dic];
            if(model){
                [models addObject:model];
            }
        }
        
        if (success){
            success(models);
        }
    }else{
        if (fail){
            fail([NSError errorWithDescription:@"responseObject 类型错误,与接口文档不符!"]);
        }
    }
}

- (void)analysisChapterListWithObj:(id  _Nullable)responseObject Success:(BookInfosSuccess)success Fail:(Fail)fail
{
    if ([responseObject isKindOfClass:[NSArray class]]){
        NSArray* data = (NSArray*)responseObject;
        NSMutableArray* models = [NSMutableArray array];
        for (NSDictionary* dic in data) {
            BookChapterModel* model = [[BookChapterModel alloc] initWithDic:dic];
            if(model){
                [models addObject:model];
            }
        }
        
        /* 保存*/
        [self.database saveChaptersWithModelArray:models];
        
        if (success){
            success(models);
        }
        
    }else{
        if (fail){
            fail([NSError errorWithDescription:@"responseObject 类型错误,与接口文档不符!"]);
        }
    }
}

@end
