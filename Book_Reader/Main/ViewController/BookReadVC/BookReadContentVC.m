//
//  BookReadContentVC.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookReadContentVC.h"
#import "BookReadTextView.h"
#import "NSDate+Utils.h"

@interface BookReadContentVC ()
@property (nonatomic,strong) BookReadTextView* contentView;
@property (nonatomic,strong) UILabel* chapterNameLabel;
@property (nonatomic,strong) UILabel* indexLabel;
@property (nonatomic,strong) UILabel* timeLabel;
@end

@implementation BookReadContentVC

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (HYUserDefault.PageTransitionStyle==UIPageViewControllerTransitionStyleScroll)
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyReadContentTouchEnd object:nil];
}

- (instancetype)initWithText:(NSString*)text
                 chapterName:(NSString*)chapterName
                    totalNum:(NSInteger)totalNum
                       index:(NSInteger)index
{
    self = [super init];
    if(self){
        self.text           = text;
        self.chapterName    = chapterName;
        self.totalNum       = totalNum;
        self.index          = index;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialSubViews];
    [self initialSubViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (HYUserDefault.isNightStyle){
        self.view.backgroundColor   = UIHexColor(0x171a21);
        _chapterNameLabel.textColor = UIHexColor(0x576071);
        _indexLabel.textColor       = UIHexColor(0x576071);
        _timeLabel.textColor        = UIHexColor(0x576071);
    }
    
    [self initialData];
}

- (void)initialSubViews
{
    _contentView = [[BookReadTextView alloc] initWithText:_text];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    self.view.backgroundColor = HYUserDefault.readBackColor?:UIHexColor(0xa39e8b);
    
    _chapterNameLabel = [[UILabel alloc] init];
    _chapterNameLabel.text = self.chapterName;
    _chapterNameLabel.font = [UIFont systemFontOfSize:12];
    _chapterNameLabel.textColor = HYUserDefault.readInfoColor?:UIHexColor(0x655a46);
    [self.view addSubview:_chapterNameLabel];
    
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.textColor  = HYUserDefault.readInfoColor?:UIHexColor(0x655a46);
    _indexLabel.text = [NSString stringWithFormat:@"第%ld/%ld页",self.index,self.totalNum];
    _indexLabel.font = [UIFont systemFontOfSize:12];
    _indexLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_indexLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = HYUserDefault.readInfoColor?:UIHexColor(0x655a46);
    [self.view addSubview:_timeLabel];
    
    [self initialData];
}

- (void)initialSubViewConstraints
{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(30);
        make.bottom.mas_equalTo(-30);
    }];
    
    [_chapterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-8);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(150);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-8);
        make.left.mas_equalTo(15);
        make.right.equalTo(self->_indexLabel.mas_left).offset(-8);
    }];
}

- (void)initialData
{
    _timeLabel.text = [NSDate strHHmm:[NSDate date]];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/**
 * 生成页面"背面图"
 */
- (UIViewController*)backImageV
{
    UIViewController* bvc = [[UIViewController alloc] init];
    bvc.view.backgroundColor = self.view.backgroundColor;

    CGRect rect = self.view.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGAffineTransform transform = CGAffineTransformMake(-1.0, 0, 0, 1.0, rect.size.width, 0.0);
    CGContextConcatCTM(context, transform);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* imageV = [[UIImageView alloc] initWithImage:screenshot];
    imageV.frame = self.view.bounds;
    imageV.alpha = 0.5;
    [bvc.view addSubview:imageV];
    
    return bvc;
}

- (UIViewController *)backVC
{
    return [self backImageV];
}

@end
