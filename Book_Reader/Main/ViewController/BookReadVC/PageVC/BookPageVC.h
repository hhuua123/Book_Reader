//
//  BookPageVC.h
//  Book_Reader
//
//  Created by hhuua on 2019/2/20.
//  Copyright © 2019 hhuua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^touchBlock)(void);
@interface BookPageVC : UIPageViewController

@property (nonatomic, strong) touchBlock block;

@end

NS_ASSUME_NONNULL_END
