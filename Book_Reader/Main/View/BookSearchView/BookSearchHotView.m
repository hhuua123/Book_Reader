//
//  BookSearchHotView.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/28.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookSearchHotView.h"

@interface BookSearchHotView()
@property(nonatomic, strong) NSMutableArray *rowsContainer;
@property(nonatomic, assign) CGFloat selfHeight;
@property(nonatomic, assign) CGRect selfFrame;

@end
/// button 文字两边空隙
CGFloat const btnEnhanceW = 18;
/// button 左右之间间距
CGFloat const btnMargin = 12;
/// button 上下间距
CGFloat const btnMarginTB = 10;
/// button 高度
CGFloat const btnH = 25;

@implementation BookSearchHotView

#pragma mark - Setter

- (void)setHistoryWordsArr:(NSArray<NSString *> *)historyWordsArr {
    _historyWordsArr = historyWordsArr;
    [self.rowsContainer
     enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx,
                                  BOOL *_Nonnull stop) {
         [obj enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx,
                                           BOOL *_Nonnull stop) {
             [obj removeFromSuperview];
         }];
     }];
    [self.rowsContainer removeAllObjects];
    
    NSUInteger count = historyWordsArr.count;
    CGFloat tempSum = 0;
    
    NSMutableArray *btnsArr = [NSMutableArray array];
    [self.rowsContainer addObject:btnsArr];
    
    for (int i = 0; i < count; i++) {
        NSString *hitoryWord = historyWordsArr[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:hitoryWord forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(keywordBtnDidClick:)
         forControlEvents:UIControlEventTouchUpInside];
        button.tag = 20;
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button.layer setBorderWidth:0.3];
        [button.layer setCornerRadius:5.0];
        [button.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [button sizeToFit];
        [self addSubview:button];
        CGFloat btnW = button.bounds.size.width + btnEnhanceW + btnMargin;
        
        tempSum += btnW;
        
        if (tempSum < self.bounds.size.width + btnMargin) {
            [btnsArr addObject:button];
        } else {
            tempSum = btnW;
            btnsArr = [NSMutableArray array];
            [btnsArr addObject:button];
            [_rowsContainer addObject:btnsArr];
        }
    }
    
    CGFloat btnY = 0;
    for (int index = 0; index < self.rowsContainer.count; index++) {
        NSArray<UIButton *> *btnsArr = self.rowsContainer[index];
        if (index == 0) {
            btnY = 15;
        } else {
            btnY = 15 + (btnH + btnMarginTB) * index;
        }
        for (int i = 0; i < btnsArr.count; i++) {
            
            UIButton *button = (UIButton *)[btnsArr objectAtIndex:i];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button sizeToFit];
            if (i == 0) {
                button.frame =
                CGRectMake(20, btnY, button.bounds.size.width + btnEnhanceW, btnH);
            } else {
                button.frame =
                CGRectMake(CGRectGetMaxX(btnsArr[i - 1].frame) + btnMargin, btnY,
                           button.bounds.size.width + btnEnhanceW, btnH);
            }
            if (index == self.rowsContainer.count - 1 && i == btnsArr.count - 1) {
                _selfHeight = CGRectGetMaxY(button.frame);
                [self setNeedsLayout];
            }
        }
    }
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _selfFrame = frame;
}
#pragma mark - getter

- (NSMutableArray *)rowsContainer {
    if (!_rowsContainer) {
        _rowsContainer = [[NSMutableArray alloc] init];
    }
    return _rowsContainer;
}
#pragma mark - private method
- (void)keywordBtnDidClick:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    
    if (self.selectBlock){
        self.selectBlock(title);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(_selfFrame.origin.x, _selfFrame.origin.y,
                            _selfFrame.size.width, _selfHeight + 8);
}

@end
