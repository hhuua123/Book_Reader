//
//  UnsplashImageCell.h
//  Book_Reader
//
//  Created by hhuua on 2019/3/4.
//  Copyright © 2019 hhuua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnsplashImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnsplashImageCell : UICollectionViewCell

@property (nonatomic,strong) UnsplashImageModel* model;
- (BOOL)reloadImage;

@end

NS_ASSUME_NONNULL_END
