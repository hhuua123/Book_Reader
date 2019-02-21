//
//  BookReadTextView.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookReadTextView.h"
#import <CoreText/CoreText.h>

@implementation BookReadTextView

- (instancetype)initWithText:(NSString*)text
{
    self = [super init];
    if (self){
        self.text = text;
        self.backgroundColor = HYUserDefault.readBackColor?:UIHexColor(0xa39e8b);
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /* 翻转坐标系*/
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:HYUserDefault.userReadAttConfig];
    if (HYUserDefault.isNightStyle){
        [dic setObject:UIHexColor(0x576071) forKey:NSForegroundColorAttributeName];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.text?:@"" attributes:dic];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height), NULL);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [attrString length]), path, NULL);
    
    /* 绘制文本*/
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
}


@end
