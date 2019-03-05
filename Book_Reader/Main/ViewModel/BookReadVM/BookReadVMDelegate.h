//
//  BookReadVMDelegate.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookInfoModel.h"

#ifndef BookReadVMDelegate_h
#define BookReadVMDelegate_h

typedef void (^block)(void);
typedef void (^LoadSuccess)(UIViewController* currentVC);
typedef void (^Fail)(NSError* err);

typedef void (^HubSuccess)(NSString* text);
typedef void (^HubFail)(NSString* text);

@protocol BookReadVMDelegate <NSObject>
@required

/* 开始初始化*/
- (void)startInit;

/* 获取前一个界面*/
- (UIViewController*)viewControllerBeforeViewController:(UIViewController *)viewController DoubleSided:(BOOL)doubleSided;

/* 获取后一界面*/
- (UIViewController*)viewControllerAfterViewController:(UIViewController *)viewController DoubleSided:(BOOL)doubleSided;

/* 按照序号加载章节*/
- (void)loadChapterWithIndex:(NSInteger)index;

/* 获取书名*/
- (NSString*)getBookName;

/* 获取所有的章节名称*/
- (NSArray<NSString*>*)getAllChapters;

/* 获取当前章节的index*/
- (NSInteger)getCurrentChapterIndex;

- (NSInteger)getCurrentVCIndexWithVC:(UIViewController*)vc;
- (NSInteger)getCurrentVCIndex;

/* 刷新所有页面*/
- (void)reloadContentViews;

#pragma mark - 用于viewmodel与vc的反向交互
/**
 * 初始化
 * 该方法在ReadVC开始加载某一章节时调用
 */
- (void)startLoadData:(block)block;

/**
 * 该方法给VM传入block,用于VM与VC的方向交互
 */
- (void)loadDataWithSuccess:(LoadSuccess)success Fail:(Fail)fail;

/**
 * 该方法用于VM控制VC显示相对应的hub
 */
- (void)showHubWithSuccess:(HubSuccess)success Fail:(HubSuccess)fail;

@optional
/* 获取所有的界面*/
- (NSArray<UIViewController *> *)viewModelGetAllVCs;

/* 获取书本信息model*/
- (BookInfoModel*)getBookInfoModel;

/* 删除当前章节的缓存*/
- (void)deleteChapterSave;

/* 删除全书章节缓存*/
- (void)deleteBookChapterSave;


@end


#endif /* BookReadVMDelegate_h */
