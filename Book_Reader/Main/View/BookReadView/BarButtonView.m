//
//  BarButtonView.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/27.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BarButtonView.h"

@interface BarButtonView()
@property (nonatomic,strong) UIImageView* imageV;
@property (nonatomic,strong) UILabel* label;
@end
@implementation BarButtonView

- (instancetype)initWithImageName:(NSString*)imageName Title:(NSString*)title
{
    self = [super init];
    if (self){
        self.frame = CGRectMake(0, 0, 40, 40);
        
        UIImageView* imageV = [[UIImageView alloc] initWithImage:kGetImage(imageName)];
        [self addSubview:imageV];
        UILabel* label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:11];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIHexColor(0x696969);
        [self addSubview:label];
        
        imageV.frame = CGRectMake(12.5, 3, 15, 15);
        label.frame = CGRectMake(0, 18, 45, 20);
        
        self.imageV = imageV;
        self.label = label;
    }
    return self;
}

- (void)changeImageName:(NSString*)imageName Title:(NSString*)title
{
    self.imageV.image = kGetImage(imageName);
    self.label.text = title;
}


@end
