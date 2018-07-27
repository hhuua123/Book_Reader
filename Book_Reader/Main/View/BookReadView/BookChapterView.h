//
//  BookChapterView.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/28.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookChapterModel.h"

/* 目录界面*/
typedef void (^select)(NSInteger index);

@interface BookChapterView : UIView

@property (nonatomic,copy) NSString* bookName;

@property (nonatomic,strong) NSArray<NSString*>* chapters;
@property (nonatomic,assign) BOOL isShowMulu;
@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) select didSelectChapter;

@end
