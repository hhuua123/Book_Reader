//
//  BookSearchHotView.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/28.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 搜索热词的显示页面*/
typedef void (^select)(NSString* title);
@interface BookSearchHotView : UIView

@property (nonatomic, strong) NSArray<NSString *> *historyWordsArr;
@property (nonatomic,strong) select selectBlock;

@end
