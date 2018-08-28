//
//  BookSetingView.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/28.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookSetingView.h"

@interface BookSetingView()
/* 字号*/
@property (nonatomic,strong) UILabel* fontTitleLabel;
@property (nonatomic,strong) UIButton* fontAddBtn;
@property (nonatomic,strong) UIButton* fontSubBtn;

/* 间距*/
@property (nonatomic,strong) UILabel* spaceTitleLabel;
@property (nonatomic,strong) UIButton* spaceBtn1;
@property (nonatomic,strong) UIButton* spaceBtn2;
@property (nonatomic,strong) UIButton* spaceBtn3;

/* 翻页*/
@property (nonatomic,strong) UILabel* transitionTitleLabel;
@property (nonatomic,strong) UIButton* tranPageCurlBtn;
@property (nonatomic,strong) UIButton* tranScrollBtn;

/* 亮度*/
@property (nonatomic,strong) UILabel* lightTitleLabel;
@property (nonatomic,strong) UISlider* lightSlider;

/* 背景*/
@property (nonatomic,strong) UILabel* backTitleLabel;
@property (nonatomic,strong) UIButton* backBtn1;
@property (nonatomic,strong) UIButton* backBtn2;
@property (nonatomic,strong) UIButton* backBtn3;
@property (nonatomic,strong) UIButton* backBtn4;

@end
@implementation BookSetingView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self initialSubViews];
        [self initSubViewConstraints];
    }
    return self;
}

- (void)initialSubViews
{
    self.backgroundColor = UIHexColor(0xf1f1f1);
    
    _fontTitleLabel = [self titleLabelWithTitle:@"字体"];
    [self addSubview:_fontTitleLabel];
    
    _fontAddBtn = [self btnWithTitle:@"A+"];
    [_fontAddBtn addTarget:self action:@selector(fontSizeUpClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_fontAddBtn];
    
    _fontSubBtn = [self btnWithTitle:@"A-"];
    [_fontSubBtn addTarget:self action:@selector(fontSizeDownClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_fontSubBtn];
    
    _spaceTitleLabel = [self titleLabelWithTitle:@"间距"];
    [self addSubview:_spaceTitleLabel];
    
    _spaceBtn1 = [self btnWithTitle:@""];
    [_spaceBtn1 addTarget:self action:@selector(lineSpacingClick:) forControlEvents:UIControlEventTouchUpInside];
    [_spaceBtn1 setImage:kGetImage(@"space_1") forState:UIControlStateNormal];
    [self addSubview:_spaceBtn1];
    
    _spaceBtn2 = [self btnWithTitle:@""];
    [_spaceBtn2 addTarget:self action:@selector(lineSpacingClick:) forControlEvents:UIControlEventTouchUpInside];
    [_spaceBtn2 setImage:kGetImage(@"space_2") forState:UIControlStateNormal];
    [self addSubview:_spaceBtn2];
    
    _spaceBtn3 = [self btnWithTitle:@""];
    [_spaceBtn3 addTarget:self action:@selector(lineSpacingClick:) forControlEvents:UIControlEventTouchUpInside];
    [_spaceBtn3 setImage:kGetImage(@"space_3") forState:UIControlStateNormal];
    [self addSubview:_spaceBtn3];
    
    _transitionTitleLabel = [self titleLabelWithTitle:@"翻页"];
    [self addSubview:_transitionTitleLabel];
    
    _tranPageCurlBtn = [self btnWithTitle:@"仿真"];
    [_tranPageCurlBtn addTarget:self action:@selector(transitionClick:) forControlEvents:UIControlEventTouchUpInside];
    _tranPageCurlBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:_tranPageCurlBtn];
    
    _tranScrollBtn = [self btnWithTitle:@"滑动"];
    [_tranScrollBtn addTarget:self action:@selector(transitionClick:) forControlEvents:UIControlEventTouchUpInside];
    _tranScrollBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:_tranScrollBtn];
    
    _lightTitleLabel = [self titleLabelWithTitle:@"亮度"];
    [self addSubview:_lightTitleLabel];
    
    _lightSlider = [[UISlider alloc] init];
    _lightSlider.minimumValue = 0;
    _lightSlider.maximumValue = 0.7;
    _lightSlider.value = HYUserDefault.readBrightness;
    _lightSlider.minimumValueImage = kGetImage(@"setting_sun_l");
    _lightSlider.maximumValueImage = kGetImage(@"setting_sun_s");
    _lightSlider.minimumTrackTintColor = UIHexColor(0x44b750);
    _lightSlider.maximumTrackTintColor = UIHexColor(0x696969);
    [_lightSlider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_lightSlider];
    
    _backTitleLabel = [self titleLabelWithTitle:@"背景"];
    [self addSubview:_backTitleLabel];
    
    _backBtn1 = [self backBtnWithColor:UIHexColor(0xf5f5f2)];
    [_backBtn1 addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn1];
    
    _backBtn2 = [self backBtnWithColor:UIHexColor(0xa39e8b)];
    [_backBtn2 addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn2];
    
    _backBtn3 = [self backBtnWithColor:UIHexColor(0xfbe1e1)];
    [_backBtn3 addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn3];
    
    _backBtn4 = [self backBtnWithColor:UIHexColor(0xd5e7c8)];
    [_backBtn4 addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn4];
    
    
    [self reloadSpaceBtn];
    [self reloadTransition];
    [self reloadBackColor];
}

- (void)initSubViewConstraints
{
    [_fontTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(40);
        make.centerY.equalTo(self.fontAddBtn.mas_centerY);
        make.height.mas_equalTo(22);
    }];
    
    [_fontSubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.equalTo(self.fontTitleLabel.mas_right).offset(20);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo((kScreenWidth-118)/2);
    }];
    
    [_fontAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.equalTo(self.fontSubBtn.mas_right).offset(8);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo((kScreenWidth-118)/2);
    }];
    
    [_spaceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(40);
        make.centerY.equalTo(self.spaceBtn1.mas_centerY);
        make.height.mas_equalTo(22);
    }];
    
    [_spaceBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fontAddBtn.mas_bottom).offset(20);
        make.left.equalTo(self.spaceTitleLabel.mas_right).offset(20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo((kScreenWidth-126)/3);
    }];
    
    [_spaceBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fontAddBtn.mas_bottom).offset(20);
        make.left.equalTo(self.spaceBtn1.mas_right).offset(8);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo((kScreenWidth-126)/3);
    }];
    
    [_spaceBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fontAddBtn.mas_bottom).offset(20);
        make.left.equalTo(self.spaceBtn2.mas_right).offset(8);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo((kScreenWidth-126)/3);
    }];
    
    [_transitionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(40);
        make.centerY.equalTo(self.tranScrollBtn.mas_centerY);
        make.height.mas_equalTo(22);
    }];
    
    [_tranPageCurlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.spaceBtn1.mas_bottom).offset(20);
        make.left.equalTo(self.transitionTitleLabel.mas_right).offset(20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo((kScreenWidth-118)/2);
    }];
    
    [_tranScrollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.spaceBtn1.mas_bottom).offset(20);
        make.left.equalTo(self.tranPageCurlBtn.mas_right).offset(20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo((kScreenWidth-118)/2);
    }];
    
    [_lightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(40);
        make.centerY.equalTo(self.lightSlider.mas_centerY);
        make.height.mas_equalTo(22);
    }];
    
    [_lightSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tranPageCurlBtn.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(self.lightTitleLabel.mas_right).offset(20);
        make.width.mas_equalTo(kScreenWidth-110);
    }];
    
    [_backTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(40);
        make.centerY.equalTo(self.backBtn1.mas_centerY);
        make.height.mas_equalTo(22);
    }];
    
    [_backBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lightSlider.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.backTitleLabel.mas_right).offset(20);
        make.width.mas_equalTo((kScreenWidth-134)/4);
    }];
    
    [_backBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lightSlider.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.backBtn1.mas_right).offset(8);
        make.width.mas_equalTo((kScreenWidth-134)/4);
    }];
    
    [_backBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lightSlider.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.backBtn2.mas_right).offset(8);
        make.width.mas_equalTo((kScreenWidth-134)/4);
    }];
    
    [_backBtn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lightSlider.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.backBtn3.mas_right).offset(8);
        make.width.mas_equalTo((kScreenWidth-134)/4);
    }];
}

#pragma mark - init
- (UILabel*)titleLabelWithTitle:(NSString*)title
{
    UILabel* label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.text = title;
    label.textColor = UIHexColor(0x838383);
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (UIButton*)btnWithTitle:(NSString*)title
{
    UIButton* btn = [[UIButton alloc] init];
    btn.backgroundColor = UIHexColor(0xf8f8f8);
    btn.layer.cornerRadius = 3;
    btn.titleLabel.font = [UIFont systemFontOfSize:25];
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 0.5;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIHexColor(0x838383) forState:UIControlStateNormal];
    return btn;
}

- (UIButton*)backBtnWithColor:(UIColor*)color
{
    UIButton* btn = [[UIButton alloc] init];
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = color;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 0.5;
    return btn;
}

#pragma mark - reloadView
- (void)reloadSpaceBtn
{
    NSDictionary* dic = HYUserDefault.userReadAttConfig;
    NSMutableParagraphStyle *paragraphStyle = [dic objectForKey:NSParagraphStyleAttributeName];
    
    self.spaceBtn1.backgroundColor = UIHexColor(0xf8f8f8);
    self.spaceBtn2.backgroundColor = UIHexColor(0xf8f8f8);
    self.spaceBtn3.backgroundColor = UIHexColor(0xf8f8f8);
    
    if (paragraphStyle.lineSpacing==15.0f){
        self.spaceBtn1.backgroundColor = UIHexColor(0xd1d1d1);
    }else if (paragraphStyle.lineSpacing==8.0f){
        self.spaceBtn2.backgroundColor = UIHexColor(0xd1d1d1);
    }else{
        self.spaceBtn3.backgroundColor = UIHexColor(0xd1d1d1);
    }
}

- (void)reloadTransition
{
    UIPageViewControllerTransitionStyle PageTransitionStyle = HYUserDefault.PageTransitionStyle;
    
    self.tranPageCurlBtn.backgroundColor = UIHexColor(0xf8f8f8);
    self.tranScrollBtn.backgroundColor = UIHexColor(0xf8f8f8);
    
    if (PageTransitionStyle == UIPageViewControllerTransitionStylePageCurl){
        self.tranPageCurlBtn.backgroundColor = UIHexColor(0xd1d1d1);
    }else{
        self.tranScrollBtn.backgroundColor = UIHexColor(0xd1d1d1);
    }
}

- (void)reloadBackColor
{
    UIColor* backColor = HYUserDefault.readBackColor;
    
    _backBtn1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _backBtn1.layer.borderWidth = 0.5;
    
    _backBtn2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _backBtn2.layer.borderWidth = 0.5;
    
    _backBtn3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _backBtn3.layer.borderWidth = 0.5;
    
    _backBtn4.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _backBtn4.layer.borderWidth = 0.5;
    
    
    if (CGColorEqualToColor(backColor.CGColor, UIHexColor(0xf5f5f2).CGColor)){
        _backBtn1.layer.borderColor = UIHexColor(0x44b750).CGColor;
        _backBtn1.layer.borderWidth = 2.0;
        
    }else if (CGColorEqualToColor(backColor.CGColor, UIHexColor(0xa39e8b).CGColor)){
        _backBtn2.layer.borderColor = UIHexColor(0x44b750).CGColor;
        _backBtn2.layer.borderWidth = 2.0;
        
    }else if (CGColorEqualToColor(backColor.CGColor, UIHexColor(0xfbe1e1).CGColor)){
        _backBtn3.layer.borderColor = UIHexColor(0x44b750).CGColor;
        _backBtn3.layer.borderWidth = 2.0;
        
    }else if (CGColorEqualToColor(backColor.CGColor, UIHexColor(0xd5e7c8).CGColor)){
        _backBtn4.layer.borderColor = UIHexColor(0x44b750).CGColor;
        _backBtn4.layer.borderWidth = 2.0;
    }
    
}

#pragma mark - target
- (void)sliderValueChange
{
    HYUserDefault.readBrightness = self.lightSlider.value;
    if (self.sliderValueBlock){
        self.sliderValueBlock();
    }
}

- (void)colorBtnClick:(UIButton*)btn
{
    if (btn==self.backBtn1){
        HYUserDefault.readBackColor = UIHexColor(0xf5f5f2);
    }else if (btn==self.backBtn2){
        HYUserDefault.readBackColor = UIHexColor(0xa39e8b);
    }else if (btn==self.backBtn3){
        HYUserDefault.readBackColor = UIHexColor(0xfbe1e1);
    }else if (btn==self.backBtn4){
        HYUserDefault.readBackColor = UIHexColor(0xd5e7c8);
    }
    
    if (self.block){
        self.block();
    }
    
    [self reloadBackColor];
}

- (void)transitionClick:(UIButton*)btn
{
    if (btn==self.tranPageCurlBtn){
        HYUserDefault.PageTransitionStyle = UIPageViewControllerTransitionStylePageCurl;
    }else if (btn==self.tranScrollBtn){
        HYUserDefault.PageTransitionStyle = UIPageViewControllerTransitionStyleScroll;
    }
    
    if (self.block){
        self.block();
    }
    
    [self reloadTransition];
}

- (void)lineSpacingClick:(UIButton*)btn
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:HYUserDefault.userReadAttConfig];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    
    if (btn==self.spaceBtn1){
        paragraphStyle.lineSpacing = 15.0f;
    }else if (btn==self.spaceBtn2){
        paragraphStyle.lineSpacing = 8.0f;
    }else if (btn==self.spaceBtn3){
        paragraphStyle.lineSpacing = 1.0f;
    }
    [dic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    HYUserDefault.userReadAttConfig = dic;
    
    if (self.block){
        self.block();
    }
    
    [self reloadSpaceBtn];
}

- (void)fontSizeDownClick
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:HYUserDefault.userReadAttConfig];
    UIFont* font = [dic objectForKey:NSFontAttributeName];
    float size = font.pointSize;
    if (size >= 6){
        UIFont* nweFont = [UIFont systemFontOfSize:size-1];
        [dic setValue:nweFont forKey:NSFontAttributeName];
        HYUserDefault.userReadAttConfig = dic;
    }
    if (self.block){
        self.block();
    }
}

- (void)fontSizeUpClick
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:HYUserDefault.userReadAttConfig];
    UIFont* font = [dic objectForKey:NSFontAttributeName];
    float size = font.pointSize;
    if (size <= 35){
        UIFont* nweFont = [UIFont systemFontOfSize:size+1];
        [dic setValue:nweFont forKey:NSFontAttributeName];
        HYUserDefault.userReadAttConfig = dic;
    }
    if (self.block){
        self.block();
    }
}

@end
