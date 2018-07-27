//
//  BookSetingView.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/28.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import <UIKit/UIKit.h>
/* 设置界面*/
typedef void (^reloadView)(void);
@interface BookSetingView : UIView

@property (nonatomic,strong) reloadView block;
@property (nonatomic,strong) reloadView sliderValueBlock;

@end
