//
//  BookReadContentVC.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 阅读界面中的"一页"*/
@interface BookReadContentVC : UIViewController

/* 该"页"需要显示的文本内容*/
@property (nonatomic,copy) NSString* text;
/* 章节名称*/
@property (nonatomic,copy) NSString* chapterName;
/* 总页数*/
@property (nonatomic,assign) NSInteger totalNum;
/* 当前页数*/
@property (nonatomic,assign) NSInteger index;

- (instancetype)initWithText:(NSString*)text
                 chapterName:(NSString*)chapterName
                    totalNum:(NSInteger)totalNum
                       index:(NSInteger)index;

@property (nonatomic,strong,readonly) UIViewController* backVC;
@end
