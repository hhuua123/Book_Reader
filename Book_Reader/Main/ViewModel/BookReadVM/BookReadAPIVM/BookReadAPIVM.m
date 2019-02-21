//
//  BookReadAPIVM.m
//  Book_Reader
//
//  Created by hhuua on 2019/2/21.
//  Copyright © 2019年 hhuua. All rights reserved.
//

#import "BookReadAPIVM.h"
#import "HYDatabase.h"
#import "HYBookAPIs.h"

@interface BookReadAPIVM()
/* 修改model为readwrite*/
@property (nonatomic,strong,readwrite) BookInfoModel* model;
/* 数据库管理*/
@property (nonatomic,strong) HYDatabase* database;
/* 书本信息相关API*/
@property (nonatomic,strong) HYBookAPIs* bookApi;
/* 章节数组*/
@property (nonatomic,strong) NSArray* chapterArr;

@end

@implementation BookReadAPIVM

- (instancetype)initWithBookModel:(BookInfoModel*)model
{
    self = [super init];
    if (self){
        self.model      = model;
        self.database   = [HYDatabase sharedDatabase];
        self.bookApi    = [[HYBookAPIs alloc] init];
    }
    return self;
}

/**
 * 初始化
 */
- (void)initialData
{
    /* 从数据库查找一次,用于处理换源的情况*/
    BookInfoModel* dbModel = [self.database selectBookInfoWithRelatedId:self.model.related_id];
    if (dbModel){
        self.model = dbModel;
    }
    /* 去数据库查找是否有本地缓存的章节信息*/
    NSArray* arr = [self.database selectChapterWithSourceUrl:self.model.book_url];
    if (arr.count >= 1){
        
        /* 已有章节缓存,去查找阅读记录*/
        self.chapterArr = [NSArray arrayWithArray:arr];
//        [self initialRecord];
        
//        [self loadChaptersWithRecord:NO];
    }else{
        
        /* 没有章节缓存,去加载章节内容*/
//        [self loadChaptersWithRecord:YES];
    }
    
}


#pragma mark - BookReadVMDelegate
- (void)reloadContentViews
{
    
}

- (NSInteger)getCurrentChapterIndex
{
    return 0;
}

- (NSInteger)getCurrentVCIndexWithVC:(UIViewController*)vc
{
    return 0;
}

- (NSInteger)getCurrentVCIndex
{
    return 0;
}

- (NSArray<NSString*>*)getAllChapters
{
    return nil;
}

- (void)loadChapterWithIndex:(NSInteger)index
{
    
}

- (NSString*)getBookName
{
    return nil;
}

- (void)startInit
{
    
}

- (void)loadDataWithSuccess:(LoadSuccess)success Fail:(Fail)fail
{
    
}

- (void)showHubWithSuccess:(HubSuccess)success Fail:(HubSuccess)fail
{
    
}

- (void)startLoadData:(block)block
{
    
}

- (UIViewController*)viewControllerBeforeViewController:(UIViewController *)viewController DoubleSided:(BOOL)doubleSided
{
    return nil;
}

- (UIViewController*)viewControllerAfterViewController:(UIViewController *)viewController DoubleSided:(BOOL)doubleSided
{
    return nil;
}

- (NSArray<UIViewController *> *)viewModelGetAllVCs
{
    return nil;
}

- (BookInfoModel*)getBookInfoModel
{
    return nil;
}

/* 删除当前章节的缓存*/
- (void)deleteChapterSave
{
    
}

/* 删除全书章节缓存*/
- (void)deleteBookChapterSave
{
    
}



@end
