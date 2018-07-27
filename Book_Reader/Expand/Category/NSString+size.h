//
//  NSString+size.h
//
//  Created by hhuua on 2017/6/25.
//  Copyright © 2017年 hhuua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (size)

/**
 * 分页
 * 给定size的大小和字符属性,计算需要几页才能显示,并返回分页后的数组。
 */
+ (NSArray*)pagingWithAttStr:(NSAttributedString*)str Size:(CGSize)size;

+ (NSArray*)pagingWith:(NSString*)text Size:(CGSize)size;

- (CGFloat)getAttributedStringHeightWithText:(NSAttributedString *)attributedString andWidth:(CGFloat)width andFont:(UIFont *)font;

@end
