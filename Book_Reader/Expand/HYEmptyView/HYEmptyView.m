//
//  HYEmptyView.m
//
//  Created by hhuua on 2017/6/19.
//  Copyright © 2017年 hhuua. All rights reserved.
//

#import "HYEmptyView.h"
#import "UIView+HYView.h"
#import "HYMacros.h"
#import <Masonry/Masonry.h>

@interface HYEmptyView()

@property (nonatomic,strong) UIImageView* imageV;
@property (nonatomic,strong) UILabel* infoLabel;
@property (nonatomic,strong) UIButton* refreshBtn;
@property (nonatomic,weak) UIView* emptySuperView;

@property (nonatomic,assign) BOOL isNetReachablity;
@property (nonatomic,strong) netStatusChange netChangeBlock;
@property (nonatomic,strong) refreshBtnClick refreshBlock;
@end

@implementation HYEmptyView

- (instancetype)initWithSuperView:(UIView*)superView
{
    return [self initWithSuperView:superView AutoNetReachablity:NO NetStatusChange:nil];
}

- (instancetype)initWithSuperView:(UIView*)superView
               AutoNetReachablity:(BOOL)netReachablity
                  NetStatusChange:(netStatusChange)netBlock
{
    self = [super init];
    if(self){
        self.emptySuperView         = superView;
        self.isNetReachablity       = netReachablity;
        self.netChangeBlock         = netBlock;
        
        [self initSubViews];
        [self initSubViewConstraints];
        [self initReachability];
    }
    return self;
}

#pragma mark - changeEmptyView
- (void)removeEmptyView
{
    [self removeFromSuperview];
}

- (void)changeEmptyViewToNetErrorWith:(refreshBtnClick)target
{
    [self changeWithImage:[UIImage imageNamed:@"HYEmptyViewImage.bundle/empty_error"]
                     Info:@"当前网络不可用"
                 BtnTitle:@"点击刷新"
                   Target:target];
    
}

- (void)changeEmptyViewToNoDataWith:(refreshBtnClick)target
{
    [self changeWithImage:[UIImage imageNamed:@"HYEmptyViewImage.bundle/empty_noData"]
                     Info:@"暂无书本信息"
                 BtnTitle:@"刷新"
                   Target:target];
}

- (void)changeEmptyViewToNoUserWith:(refreshBtnClick)target
{
    [self changeWithImage:[UIImage imageNamed:@"HYEmptyViewImage.bundle/empty_info"]
                     Info:@"您的个人信息还不完整,请完善个人信息"
                 BtnTitle:@"完善信息"
                   Target:target];
}

- (void)changeEmptyViewToBuild
{
    [self changeWithImage:[UIImage imageNamed:@"HYEmptyViewImage.bundle/empty_buliding"]
                     Info:@"项目正在建设中\n敬请期待"
                 BtnTitle:@""
                   Target:nil];
}

- (void)changeEmptyViewWithNetStatus:(HYNetReachabilityStatus)status
{
    if(!self.isNetReachablity){
        return;
    }
    
    if(self.netChangeBlock){
        self.netChangeBlock(self.reachability, status);
    }
}

- (void)changeWithImage:(UIImage*)image
                   Info:(NSString*)info
               BtnTitle:(NSString*)btnTitle
                 Target:(refreshBtnClick)target
{
    if(!_emptySuperView){
        [self removeFromSuperview];
        return;
    }
    self.refreshBtn.hidden = btnTitle.length<1;
    
    [self setEmptyImage:image];
    [self setInfoTitle:info];
    [self setRefreshBtnTitle:btnTitle];
    [self setRefreshBlock:target];
    
    [self.emptySuperView addSubview:self];
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.emptySuperView);
    }];
    
    [self initSubViewConstraints];
}

#pragma mark - initUI
- (void)initSubViews
{
    self.backgroundColor = UIHexColor(0xeeeeee);
    
    _imageV = [[UIImageView alloc] initWithImage:_emptyImage];
    [self addSubview:_imageV];
    
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.font = [UIFont systemFontOfSize:18];
    _infoLabel.textColor = [UIColor grayColor];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.numberOfLines = 2;
    [self addSubview:_infoLabel];
    
    _refreshBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _refreshBtn.layer.borderColor = UIHexColor(646464).CGColor;
    [_refreshBtn setTitleColor:UIHexColor(0x646464) forState:UIControlStateNormal];
    _refreshBtn.layer.borderWidth = 0.5;
    _refreshBtn.layer.cornerRadius = 3;
    [_refreshBtn addTarget:self action:@selector(refreshClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_refreshBtn];
}

- (void)initSubViewConstraints
{
    float imageH = 80;
    float center;
    if(_refreshBtnTitle.length>0)
        center = 80;
    else
        center = 50;
    [_imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@(-center));
        make.width.height.mas_equalTo(imageH);
        make.centerX.equalTo(self);
    }];
    
    [_infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.left.equalTo(@40);
        make.top.equalTo(self.imageV.mas_bottom).offset(20);
        make.centerX.equalTo(self.imageV);
    }];
    
    [_refreshBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@120);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(8);
        make.centerX.equalTo(self.imageV);
    }];
}

- (void)initReachability
{
    if(!self.isNetReachablity){
        return;
    }
    
    self.reachability = [HYNetReachability sharedNewReachability];
    WeakSelf(weakSelf);
    [self.reachability addTargetWithBlock:^(HYNetReachability *reachability, HYNetReachabilityStatus status) {
        StrongSelf(strongSelf);
        if(!strongSelf){
            return ;
        }
        
        [strongSelf changeEmptyViewWithNetStatus:status];
    }];
    [self.reachability startMonitorNetReachability];
    
}

#pragma mark - target
- (void)refreshClick
{
    if(_refreshBlock){
        _refreshBlock();
    }
}
     
#pragma mark - set
- (void)setEmptyImage:(UIImage *)emptyImage
{
    _emptyImage = emptyImage;
    _imageV.image = _emptyImage;
}

- (void)setRefreshBtnTitle:(NSString *)refreshBtnTitle
{
    _refreshBtnTitle = refreshBtnTitle;
    [_refreshBtn setTitle:_refreshBtnTitle forState:UIControlStateNormal];
}

- (void)setInfoTitle:(NSString *)infoTitle
{
    _infoTitle = infoTitle;
    _infoLabel.text = _infoTitle;
}

@end
