//
//  HYFlowLayout.m
//  Book_Reader
//
//  Created by hhuua on 2019/3/4.
//  Copyright © 2019 hhuua. All rights reserved.
//

#import "HYFlowLayout.h"
#import "HYHigherOrderFunc.h"

@interface HYFlowLayout()
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *eachColumnMaxHight;

@end

@implementation HYFlowLayout

-(void)prepareLayout
{
    /* 清空之前计算的值*/
    self.dataArr = nil;
    self.eachColumnMaxHight = nil;
    
    if (_headerSize.height > 0){
        UICollectionViewLayoutAttributes * layoutHeader = [UICollectionViewLayoutAttributes   layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathWithIndex:0]];
        layoutHeader.frame = CGRectMake(0,0, _headerSize.width, _headerSize.height);
        [self.dataArr addObject:layoutHeader];
    }
    
    NSInteger itemNum= [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < itemNum; i++) {
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexpath];
        
        CGFloat contentW = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right;
        CGFloat itemW = (contentW - (self.colCount - 1) * self.minimumInteritemSpacing - _edgeInsets.left - _edgeInsets.right) / self.colCount;
        
        CGSize iSize = [(NSValue*)self.sizeList[i] CGSizeValue];
        CGFloat itemH = itemW * ((float)iSize.height /(float)iSize.width);
        
        if (_itemMinHeight > 0 && itemH < _itemMinHeight)
            itemH = _itemMinHeight;
        
        if (_itemMaxHeight > 0 && itemH > _itemMaxHeight)
            itemH = _itemMaxHeight;
        
        /* 选择行数的时候,优先选择当前行高较为低的一列*/
        NSInteger colNum = 0;
        float maxH = MAXFLOAT;
        for (NSInteger i = 0; i < _eachColumnMaxHight.count; i++) {
            NSNumber* num = _eachColumnMaxHight[i];
            if (num.floatValue < maxH){
                maxH = num.floatValue;
                colNum = i;
            }
        }
        
        CGFloat itemX = self.sectionInset.left + (itemW + self.minimumInteritemSpacing) * colNum;
        CGFloat itemY = [self.eachColumnMaxHight[colNum] floatValue];
        
        if (itemY == 0){
            itemY += _edgeInsets.top;
            if (_headerSize.height > 0)
                itemY += _headerSize.height;
        }
        
        attr.frame = CGRectMake(itemX, itemY, itemW, itemH);
        
        self.eachColumnMaxHight[colNum] = @(itemY + itemH + self.minimumLineSpacing);
        [self.dataArr addObject:attr];
    }
}

-(CGSize)collectionViewContentSize
{
    NSInteger maxCol = [self calculateMaxHeightCol];
    CGFloat insetsTop = _edgeInsets.top;
    CGFloat insetsBot = _edgeInsets.bottom;
    return CGSizeMake(0, [self.eachColumnMaxHight[maxCol] floatValue] - self.minimumLineSpacing + insetsTop + insetsBot);
}

-(NSInteger)calculateMaxHeightCol
{
    NSInteger maxCol = 0;
    CGFloat maxHeight = 0;
    
    for (NSInteger i = 0; i < self.colCount; i++) {
        if (maxHeight < [self.eachColumnMaxHight[i] floatValue]) {
            maxHeight = [self.eachColumnMaxHight[i] floatValue];
            maxCol = i;
        }
    }
    return maxCol;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.dataArr;
}

#pragma mark - lazyload
-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)eachColumnMaxHight
{
    if (_eachColumnMaxHight == nil) {
        _eachColumnMaxHight = [NSMutableArray arrayWithCapacity:self.colCount];
        for (NSInteger i = 0; i < self.colCount; i++) {
            _eachColumnMaxHight[i] = @(self.sectionInset.top);
        }
    }
    return _eachColumnMaxHight;
}

@end
