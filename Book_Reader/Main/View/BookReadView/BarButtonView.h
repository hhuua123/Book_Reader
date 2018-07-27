//
//  BarButtonView.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/27.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import <UIKit/UIKit.h>

/* toolbar按钮(上图下字)*/
@interface BarButtonView : UIView

- (instancetype)initWithImageName:(NSString*)imageName Title:(NSString*)title;
- (void)changeImageName:(NSString*)imageName Title:(NSString*)title;

@end
