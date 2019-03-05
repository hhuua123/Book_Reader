//
//  BookReadAPIVM.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookReadAPIVM.h"
#import "HYDatabase.h"
#import "HYBookAPIs.h"
#import "BookReadContentVC.h"
#import "NSString+size.h"
#import "BookChapterTextModel.h"
#import "BookRecordModel.h"
#import "NSError+HYError.h"
#import "UIView+Screenshot.h"

@interface BookReadAPIVM()
/* 修改model为readwrite*/
@property (nonatomic,strong,readwrite) BookInfoModel* model;
/* 数据库管理*/
@property (nonatomic,strong) HYDatabase* database;
/* 书本信息相关API*/
@property (nonatomic,strong) HYBookAPIs* bookApi;
/* 当前章节*/
@property (nonatomic,strong) BookChapterModel* currentChapterModel;
/* 当前章节的内容*/
@property (nonatomic,strong) BookChapterTextModel* currentChapterTextModel;
/* 当前是第个章节*/
@property (nonatomic,assign) NSInteger currentIndex;
/* 当前页数*/
@property (nonatomic,assign) NSInteger currentVCIndex;
/* 当前页面*/
@property (nonatomic,strong) BookReadContentVC* currentVC;
/* 章节数组*/
@property (nonatomic,strong) NSArray* chapterArr;
/* 章节对应的页面数组*/
@property (nonatomic,strong) NSArray* vcArr;

#pragma mark - block
@property (nonatomic,strong) LoadSuccess loadSuccess;
@property (nonatomic,strong) Fail loadFail;
@property (nonatomic,strong) block startLoadBlock;
@property (nonatomic,strong) HubSuccess hubSuccess;
@property (nonatomic,strong) HubFail hubFail;
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
 * 初始化时应该完成的事情有:
 * 查询数据库中是否有当前书缓存的章节信息,没有则去查询,有则先使用缓存,并后台更新缓存
 * 等待上一步完成,去查找有没有阅读的记录,有则加载记录章节,没有则加载第一章
 * 等待上一步完成,去更新页面信息。
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
        [self initialRecord];
        [self loadChaptersWithRecord:NO];
    }else{
        
        /* 没有章节缓存,去加载章节内容*/
        [self loadChaptersWithRecord:YES];
    }
    
}

/**
 * 查找阅读记录
 */
- (void)initialRecord
{
    @try {
        BookRecordModel* model = [self.database selectBookRecordWithBookId:_model.related_id];
        /* 有阅读记录*/
        if (model){
            HYDebugLog(@"阅读记录:第:%ld章",model.chapter_index);
            if (model.chapter_index >= self.chapterArr.count){
                [self loadChapterTextWith:self.chapterArr.lastObject isNext:YES recordText:nil];
            }else{
                [self loadChapterTextWith:self.chapterArr[model.chapter_index] isNext:YES recordText:model.record_text];
            }
        }else{
            HYDebugLog(@"没有找到阅读记录");
            /* 没有阅读记录*/
            [self loadChapterTextWith:self.chapterArr.firstObject isNext:YES recordText:nil];
        }
    } @catch (NSException *exception) {
        HYDebugLog(@"查找书本阅读记录失败");
        if (self.loadFail){
            self.loadFail([NSError errorWithDescription:@"查找书本阅读记录失败"]);
        }
    }
}

/**
 * 保存书本的阅读记录
 */
- (void)saveBookRecordWithPageIndex:(NSInteger)pageIndex
{
    kWeakSelf(self);
    kDISPATCH_ON_GLOBAL_QUEUE_LOW(^(){
        kStrongSelf(self);
        @try {
            NSInteger chapterIndex = self.currentIndex;
            NSString* text = ((BookReadContentVC*)self.vcArr[pageIndex]).text;
            NSString* name = ((BookReadContentVC*)self.vcArr[pageIndex]).chapterName;
            NSString* record;
            
            if (text.length >= 20){
                record = [text substringToIndex:20];
            }else{
                record = text;
            }
            
            if (chapterIndex >= 0){
                BookRecordModel* model = [[BookRecordModel alloc] initWithId:self.model.related_id index:chapterIndex record:record chapterName:name];
                [self.database saveRecordWithChapterModel:model];
            }
            
        } @catch (NSException *exception) {
            HYDebugLog(@"书本阅读记录保存失败");
        }
    });
    
}

/**
 * 获取章节内容成功之后,应该进行区分
 */
- (void)pagingContentVCsWithisNext:(BOOL)isNext recordText:(NSString*)recordText
{
    NSArray* textArr = [NSString pagingWith:self.currentChapterTextModel.info Size:CGSizeMake(kScreenWidth - 30, kScreenHeight - 60)];
    NSMutableArray* vcs = [NSMutableArray array];
    
    NSInteger index = 0;
    for (NSInteger len = 0; len < textArr.count; len++)
    {
        NSString* text = textArr[len];
        /* 查找记录值所在的页*/
        if (recordText){
            if ([text containsString:recordText]){
                index = len;
            }
        }
        /* 初始化显示界面*/
        BookReadContentVC* vc = [[BookReadContentVC alloc] initWithText:text chapterName:self.currentChapterModel.name totalNum:textArr.count index:len+1];
        if(vc){
            [vcs addObject:vc];
        }
    }
    
    self.vcArr = [NSArray arrayWithArray:vcs];
    
    BookReadContentVC* currenVC;
    
    /* 通知pageView刷新界面*/
    if (!kStringIsEmpty(recordText)){
        currenVC = self.vcArr[index];
        self.currentVCIndex = index;
    }else{
        if (isNext){
            self.currentVCIndex = 0;
            currenVC = self.vcArr.firstObject;
        }else{
            self.currentVCIndex = self.vcArr.count - 1;
            currenVC = self.vcArr.lastObject;
        }
    }
    
    /* 记录阅读历史*/
    @try {
        [self saveBookRecordWithPageIndex:[self.vcArr indexOfObject:currenVC]];
    } @catch (NSException *exception) {
        HYDebugLog(@"保存阅读历史错误");
    }
    
    self.currentVC = currenVC;
    
    if (self.loadSuccess){
        self.loadSuccess(currenVC);
    }
}

/**
 * 加载章节列表
 */
- (void)loadChaptersWithRecord:(BOOL)isRecord
{
    if (isRecord){
        if (self.startLoadBlock){
            self.startLoadBlock();
        }
    }
    
    [self.bookApi chapterListWithBook:_model Success:^(NSArray<BookChapterModel *> *chapters) {
        self.chapterArr = [NSArray arrayWithArray:chapters];
        /* 去查找阅读记录*/
        if (isRecord)
            [self initialRecord];
    } Fail:^(NSError *err) {
        if (self.loadFail){
            self.loadFail(err);
        }
    }];
}

/**
 * 预加载
 */
- (void)advanceLoadChapters
{
    NSInteger index = self.currentIndex;
    NSMutableArray* chapters = [NSMutableArray array];
    NSInteger adLoadChapters = (HYUserDefault.adLoadChapters>=1?:3)<=20?:20;
    for (NSInteger i = 0; i < adLoadChapters; i++) {
        ++index;
        if (index < self.chapterArr.count){
            [chapters addObject:self.chapterArr[index]];
        }
    }
    
    if (chapters.count >= 1){
        [self.bookApi advanceLoadChapters:chapters];
    }
}

/**
 * 加载指定章节的内容
 * 该方法完成后应刷新用户显示界面
 * @param isNext 加载的是下一个章节吗
 * @param recordText 阅读记录值
 */
- (void)loadChapterTextWith:(BookChapterModel*)model isNext:(BOOL)isNext recordText:(NSString*)recordText
{
    if (self.startLoadBlock){
        self.startLoadBlock();
    }
    
    if (!model){
        if (self.loadFail){
            self.loadFail([NSError errorWithDescription:@"暂无章节信息"]);
        }
        return;
    }
    
    [self.bookApi chapterTextWithChapter:model Success:^(BookChapterTextModel *chapterText) {
        /* 改变记录值*/
        self.currentChapterModel = model;
        self.currentChapterTextModel = chapterText;
        self.currentIndex = [self.chapterArr indexOfObject:self.currentChapterModel];
        if (self.currentIndex >= self.chapterArr.count)
            self.currentIndex = 0;
        
        /* 分页*/
        @try {
            [self pagingContentVCsWithisNext:isNext recordText:recordText];
        } @catch (NSException *exception) {
            HYDebugLog(@"书本分页失败");
            if (self.loadFail){
                self.loadFail([NSError errorWithDescription:@"书本分页失败"]);
            }
        }
        
        /* 预加载*/
        [self advanceLoadChapters];
    } Fail:^(NSError *err) {
        if (self.loadFail){
            self.loadFail(err);
        }
    }];
}

/**
 * 加载上一章节,加载完成后默认在前一章节的最后一页
 */
- (void)loadBeforeChapterText
{
    HYDebugLog(@"加载上一章节");
    NSInteger index = self.currentIndex;
    if (index - 1>=0 && index - 1<self.chapterArr.count){
        BookChapterModel* model = self.chapterArr[index - 1];
        [self loadChapterTextWith:model isNext:NO recordText:nil];
    }else{
        HYDebugLog(@"chapterArr.count=%ld,index=%ld",self.chapterArr.count,index);
        if (self.hubFail){
            self.hubFail(@"已经是第一章了");
        }
    }
}

/**
 * 加载下一章节,加载完成后默认显示后一章节的第一页
 */
- (void)loadNextChapterText
{
    HYDebugLog(@"加载下一章节");
    NSInteger index = self.currentIndex;
    
    if (index + 1>=0 && index + 1<self.chapterArr.count){
        BookChapterModel* model = self.chapterArr[index + 1];
        [self loadChapterTextWith:model isNext:YES recordText:nil];
    }else{
        HYDebugLog(@"chapterArr.count=%ld,index=%ld",self.chapterArr.count,index);
        if (self.hubFail){
            self.hubFail(@"已经是最后一章了");
        }
    }
}

#pragma mark - BookReadVMDelegate
- (NSInteger)getCurrentChapterIndex
{
    return self.currentIndex;
}

- (NSInteger)getCurrentVCIndexWithVC:(UIViewController*)vc
{
    NSInteger index = [self.vcArr indexOfObject:vc];
    
    return index;
}

- (NSInteger)getCurrentVCIndex
{
    return self.currentVCIndex;
}

- (void)reloadContentViews
{
    [self initialRecord];
}

- (NSArray<NSString*>*)getAllChapters
{
    NSMutableArray* array = [NSMutableArray array];
    for (BookChapterModel* model in self.chapterArr) {
        [array addObject:model.name];
    }
    
    return array;
}

- (void)loadChapterWithIndex:(NSInteger)index
{
    if (index < self.chapterArr.count){
        BookChapterModel* model = self.chapterArr[index];
        [self loadChapterTextWith:model isNext:YES recordText:nil];
    }else{
        [self loadChapterTextWith:self.chapterArr.lastObject isNext:YES recordText:nil];
    }
}

- (NSString*)getBookName
{
    return self.model.book_name;
}

- (void)startInit
{
    /* 开始加载数据*/
    [self initialData];
}

- (void)loadDataWithSuccess:(LoadSuccess)success Fail:(Fail)fail
{
    self.loadFail = fail;
    self.loadSuccess = success;
}

- (void)showHubWithSuccess:(HubSuccess)success Fail:(HubSuccess)fail
{
    self.hubFail = fail;
    self.hubSuccess = success;
}

- (void)startLoadData:(block)block
{
    self.startLoadBlock = block;
}

/* 获取前一个界面*/
- (UIViewController*)viewControllerBeforeViewController:(UIViewController *)viewController DoubleSided:(BOOL)doubleSided
{
    /* UIPageViewController在UIPageViewControllerTransitionStyleScroll模式下,会连续向前/向后请求两次
       目前的方法只能是通过标记暂时解决一下这个问题,
     */
    static NSInteger scrollTimes;
    
    NSInteger index;
    if (doubleSided){
        index = [self.vcArr indexOfObject:self.currentVC];
        scrollTimes = 0;
    }else
        index = [self.vcArr indexOfObject:viewController];
    
    /* 返回背面*/
    if (doubleSided && [viewController isKindOfClass:[BookReadContentVC class]]){
        self.currentVC = (BookReadContentVC*)viewController;
        return self.currentVC.backVC;
    }
    
    if (index - 1 >=0 && index - 1 < self.vcArr.count){
        /* 记录阅读历史*/
        self.currentVCIndex = index - 1;
        [self saveBookRecordWithPageIndex:index - 1];
        self.currentVC = self.vcArr[index - 1];

        return self.currentVC;
    }
    if (!doubleSided && index==0){
        if (scrollTimes > 0)
            [self loadBeforeChapterText];
        else{
            BookReadContentVC* lv = self.vcArr.firstObject;
            BookReadContentVC* newV = [[BookReadContentVC alloc] initWithText:lv.text chapterName:lv.chapterName totalNum:lv.totalNum index:lv.index];
            return newV;
            
        }
        
        scrollTimes = 1;
        return nil;
    }
    /* 网络加载*/
    [self loadBeforeChapterText];
    return nil;
}

/* 获取后一界面*/
- (UIViewController*)viewControllerAfterViewController:(UIViewController *)viewController DoubleSided:(BOOL)doubleSided
{
    static NSInteger scrollTimes;
    
    NSInteger index;
    if (doubleSided){
        index = [self.vcArr indexOfObject:self.currentVC];
        scrollTimes = 0;
    }
    else
        index = [self.vcArr indexOfObject:viewController];
    
    /* 返回背面*/
    if (doubleSided && [viewController isKindOfClass:[BookReadContentVC class]]){
        self.currentVC = (BookReadContentVC*)viewController;
        return self.currentVC.backVC;
    }
    
    if (index + 1>=0 && index + 1<self.vcArr.count){
        /* 记录阅读历史*/
        self.currentVCIndex = index + 1;
        [self saveBookRecordWithPageIndex:index + 1];
        self.currentVC = self.vcArr[index + 1];
        
        return self.currentVC;
    }
    
    if (!doubleSided && index==self.vcArr.count - 1){
        if (scrollTimes > 0)
            [self loadBeforeChapterText];
        else{
            BookReadContentVC* lv = self.vcArr.lastObject;
            BookReadContentVC* newV = [[BookReadContentVC alloc] initWithText:lv.text chapterName:lv.chapterName totalNum:lv.totalNum index:lv.index];
            return newV;
            
        }
        
        scrollTimes = 1;
        return nil;
    }
    /* 网络加载*/
    [self loadNextChapterText];
    return nil;
}

- (NSArray<UIViewController *> *)viewModelGetAllVCs
{
    return self.vcArr;
}

- (BookInfoModel*)getBookInfoModel
{
    return self.model;
}

/* 删除当前章节的缓存*/
- (void)deleteChapterSave
{
    if ([self.database deleteChapterTextWithUrl:self.currentChapterTextModel.url]){
        [self loadBeforeChapterText];
    }
}

/* 删除全书章节缓存*/
- (void)deleteBookChapterSave
{
    if ([self.database deleteChapterTextWithBookId:self.model.related_id]){
        [self loadBeforeChapterText];
    }
}

@end
