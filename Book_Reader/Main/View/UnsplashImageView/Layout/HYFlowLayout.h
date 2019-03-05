//
//  HYFlowLayout.h
//  Book_Reader
//
//  Created by hhuua on 2019/3/4.
//  Copyright © 2019 hhuua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,assign) NSInteger colCount;
/* 传入的sizeList应该是一个CGSize转换的NSValue的数组*/
@property (nonatomic,strong) NSArray<NSValue*>* sizeList;

@property (nonatomic,assign) float itemMinHeight;
@property (nonatomic,assign) float itemMaxHeight;
@property (nonatomic,assign) UIEdgeInsets edgeInsets;
@property (nonatomic,assign) CGSize headerSize;

@end

NS_ASSUME_NONNULL_END
