//
//  NSString+size.m
//
//  Created by hhuua on 2017/6/25.
//  Copyright © 2017年 hhuua. All rights reserved.
//

#import "NSString+size.h"
#import <CoreText/CoreText.h>

@implementation NSString (size)

+ (NSArray*)pagingWith:(NSString*)text Size:(CGSize)size
{
    if (kDictIsEmpty(HYUserDefault.userReadAttConfig)){
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 8.0f;
        NSDictionary* dic = @{
                              NSFontAttributeName: [UIFont systemFontOfSize:15],
                              NSForegroundColorAttributeName: UIHexColor(0x311b0e),
                              NSKernAttributeName: @(0),
                              NSParagraphStyleAttributeName: paragraphStyle,
                              };
        HYUserDefault.userReadAttConfig = dic;
    }
    NSAttributedString* att = [[NSAttributedString alloc] initWithString:text attributes:HYUserDefault.userReadAttConfig];
    return [self pagingWithAttStr:att Size:size];
}

+ (NSArray*)pagingWithAttStr:(NSAttributedString*)str Size:(CGSize)size
{
    CFAttributedStringRef cfAttStr = (__bridge CFAttributedStringRef)str;
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString(cfAttStr);
    
    NSMutableArray* array = [NSMutableArray array];
    int nowLenght = 0;
    
    while (nowLenght<str.length)
    {
        CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, size.width, size.height), NULL);
        CTFrameRef frame = CTFramesetterCreateFrame(setterRef, CFRangeMake(nowLenght, 0), path, NULL);
        
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        NSRange range = NSMakeRange(frameRange.location, frameRange.length);
        
        NSString* string = [str.string substringWithRange:range];
        [array addObject:string];
        
        CGPathRelease(path);
        CFRelease(frame);
        
        if (string.length == 0){
            break;
        }else{
            nowLenght += string.length;
        }
    }
    
    CFRelease(setterRef);
    return array;
}

- (CGFloat)getAttributedStringHeightWithText:(NSAttributedString *)attributedString andWidth:(CGFloat)width andFont:(UIFont *)font
{
    static UILabel *stringLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stringLabel = [[UILabel alloc] init];
        stringLabel.numberOfLines = 0;
    });
    
    stringLabel.font = font;
    stringLabel.attributedText = attributedString;
    return [stringLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
}

@end
