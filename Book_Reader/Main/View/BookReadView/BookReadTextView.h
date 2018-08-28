//
//  BookReadTextView.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 用于文本渲染的view*/
@interface BookReadTextView : UIView

/* 需要渲染的文本*/
@property (nonatomic,copy) NSString* text;
- (instancetype)initWithText:(NSString*)text;

@end
