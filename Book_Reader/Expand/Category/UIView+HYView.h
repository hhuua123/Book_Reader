//
//  UIView+HYView.h
//  HYColor
//
//  Created by hhuua on 2016/12/8.
//  Copyright © 2016年 hhuua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HYView)

- (void)removeAllSubviews;//移除所有的子视图
@property (nonatomic, readonly) UIViewController *viewController;//拿到View的Controller

//拿到或设置View的frame与相关的各个信息
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;


/**  设置圆角  */
- (void)rounded:(CGFloat)cornerRadius;

/**  设置圆角和边框  */
- (void)rounded:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**  设置边框  */
- (void)border:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**   给哪几个角设置圆角  */
-(void)round:(CGFloat)cornerRadius RectCorners:(UIRectCorner)rectCorner;

/**  设置阴影  */
-(void)shadow:(UIColor *)shadowColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset;

@end

#ifndef kSystemValue
#define kSystemValue [UIDevice currentDevice].systemVersion.floatValue

#define kiOS7Later (kSystemValue >= 7.0f)
#define kiOS8Later (kSystemValue >= 8.0f)
#define kiOS9Later (kSystemValue >= 9.0f)
#define kiOS9_1Later (kSystemValue >= 9.1f)
#define kios10Later (kSystemValue >= 10.0f)
#define kios8toios10 (kSystemValue >= 8.0f && kSystemValue < 10.0f)

#endif

/// 屏幕宽度
#ifndef kScreenWidth
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

/// 屏幕高度
#ifndef kScreenHeight
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#endif

/// 屏幕大小
#ifndef kScreenSize
#define kScreenSize [UIScreen mainScreen].bounds.size
#endif

///屏幕bounds
#ifndef kScreenBounds
#define kScreenBounds [UIScreen mainScreen].bounds
#endif

/// 屏幕Scale
#ifndef kScreenScale
#define kScreenScale [UIScreen mainScreen].scale
#endif

#ifndef UIHexColor
#define UIHexColor(_hex_)   [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif



@interface UIColor (HYcolor)
+ (UIColor *)colorWithHexString:(NSString *)hexStr;
- (UIColor *)colorByAddColor:(UIColor *)add blendMode:(CGBlendMode)blendMode;


@end



