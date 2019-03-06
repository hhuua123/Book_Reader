//
//  BookReadVC.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookReadVC.h"
#import "BarButtonView.h"
#import "BookChapterView.h"
#import "BookSetingView.h"
#import "BookSourceListVC.h"
#import "BookPageVC.h"

@interface BookReadVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic,strong) BookPageVC *pageViewController;
@property (nonatomic,strong) BarButtonView* nightView;
@property (nonatomic,strong) BookChapterView* chapterView;
@property (nonatomic,strong) BookSetingView* settingView;
@property (nonatomic,strong) UIView* brightnessView;
@property (nonatomic,assign) BOOL isFirstLoad;

@end

@implementation BookReadVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavi];
    [self initialToolBar];
    [self initialSubViews];
    [self initialSubViewConstraints];
    [self initialData];
    
    self.isFirstLoad = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.isFirstLoad){
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.toolbarHidden = YES;
        self.settingView.hidden = YES;
    }
    
    self.isFirstLoad = NO;
    [super viewDidAppear:animated];
}

- (void)initialNavi
{
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.backgroundColor = UIHexColor(0xf1f1f1);
    
    UIButton* button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    CGSize strSize = [[self.viewModel getBookName] sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
    button.frame = CGRectMake(0, 0, strSize.width + 15, 40);
    button.tintColor = UIHexColor(0x696969);
    [button setTitleColor:UIHexColor(0x696969) forState:UIControlStateNormal];
    [button setImage:kGetImage(@"navi_backbtnImage_white") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(naviLeftBarItemClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:[self.viewModel getBookName] forState:UIControlStateNormal];
    

    UIBarButtonItem* left = [[UIBarButtonItem alloc] initWithCustomView:button];
    left.tintColor = UIHexColor(0x696969);
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem* right = [[UIBarButtonItem alloc] initWithTitle:@"换源" style:UIBarButtonItemStyleDone target:self action:@selector(naviRightBarItemClick)];
    
    right.tintColor = UIHexColor(0x696969);
    [right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:(UIControlStateNormal)];
    [right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:(UIControlStateSelected)];
    
    self.navigationItem.rightBarButtonItem = right;
    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = UIHexColor(0xf1f1f1);
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)initialToolBar
{
    UIToolbar* tabBar = self.navigationController.toolbar;
    CGRect frame = CGRectMake(0.0, 0, kScreenWidth,tabBar.height);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = UIHexColor(0xf1f1f1);
    [tabBar insertSubview:view atIndex:0];
    UIBarButtonItem* fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    BarButtonView* nightView = [[BarButtonView alloc] initWithImageName:HYUserDefault.isNightStyle?@"toolbar_day":@"toolbar_night" Title:HYUserDefault.isNightStyle?@"白天":@"夜间"];
    self.nightView = nightView;
    UIBarButtonItem* night = [[UIBarButtonItem alloc] initWithCustomView:nightView];
    
    BarButtonView* muluView = [[BarButtonView alloc] initWithImageName:@"toolbar_mulu" Title:@"目录"];
    UIBarButtonItem* mulu = [[UIBarButtonItem alloc] initWithCustomView:muluView];
    
    BarButtonView* setView = [[BarButtonView alloc] initWithImageName:@"toolbar_setting" Title:@"设置"];
    UIBarButtonItem* setButton = [[UIBarButtonItem alloc] initWithCustomView:setView];
    
    BarButtonView* readView = [[BarButtonView alloc] initWithImageName:@"toolbar_caching" Title:@"缓存"];
    UIBarButtonItem* readStyle = [[UIBarButtonItem alloc] initWithCustomView:readView];
    
    BarButtonView* backView = [[BarButtonView alloc] initWithImageName:@"toolbar_feedback" Title:@"反馈"];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithCustomView:backView];
    
    self.toolbarItems = @[mulu,fixed,night,fixed,setButton,fixed,readStyle,fixed,backButton];
    
    UITapGestureRecognizer* nightT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeNightStyle)];
    [nightView addGestureRecognizer:nightT];
    
    UITapGestureRecognizer* muluT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMulu)];
    [muluView addGestureRecognizer:muluT];
    
    UITapGestureRecognizer* setT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSettingView)];
    [setView addGestureRecognizer:setT];
    
    UITapGestureRecognizer* readT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showWait)];
    [readView addGestureRecognizer:readT];
    
    UITapGestureRecognizer* backT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBackAlert)];
    [backView addGestureRecognizer:backT];
}

- (void)initialSubViews
{
    self.view.backgroundColor = HYUserDefault.readBackColor?:UIHexColor(0xa39e8b);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    self.chapterView = [[BookChapterView alloc] initWithFrame:CGRectMake(0, 0, 0, kScreenHeight)];
    kWeakSelf(self);
    self.chapterView.didSelectChapter = ^(NSInteger index) {
        kStrongSelf(self);
        [self.viewModel loadChapterWithIndex:index];
    };
    [self.view addSubview:self.chapterView];
    
    self.settingView = [[BookSetingView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 370, kScreenWidth, 330)];
    
    self.settingView.block = ^{
        kStrongSelf(self);
        [self.viewModel reloadContentViews];
        
    };
    self.settingView.sliderValueBlock = ^{
        kStrongSelf(self);
        self.brightnessView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:HYUserDefault.readBrightness];
    };
    
    [self.view addSubview:self.settingView];
    self.settingView.hidden = YES;
    
    self.brightnessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.brightnessView.userInteractionEnabled = NO;
    self.brightnessView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:HYUserDefault.readBrightness];
    [self.view addSubview:self.brightnessView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNaviBarHidenWithAnimated) name:kNotifyReadContentTouchEnd object:nil];
}

- (void)initialData
{
#pragma mark - 设置ViewModel的反向回调
    /* 数据加载*/
    kWeakSelf(self);
    [self.viewModel loadDataWithSuccess:^(UIViewController *currentVC) {
        kStrongSelf(self);
        [self loadDataSuccess:currentVC];
    } Fail:^(NSError *err) {
        kStrongSelf(self);
        [self loadDataFail];
    }];
    
    /* 章节数据开始加载时*/
    [self.viewModel startLoadData:^{
        kStrongSelf(self);
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showMessage:@"加载中" toView:self.view delay:0.15];
    }];
    
    /* 用于ViewModel反向通知VC显示提示框*/
    [self.viewModel showHubWithSuccess:^(NSString *text) {
        [MBProgressHUD showSuccess:text toView:self.view];
    } Fail:^(NSString *text) {
        [MBProgressHUD showError:text toView:self.view];
    }];
    
    /* 通知VM,开始获取数据*/
    [self.viewModel startInit];
}

- (void)initialSubViewConstraints
{
    [_pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
}

#pragma mark - func
- (void)showWait
{
    [MBProgressHUD showSuccess:@"暂未完成" toView:self.view];
}

- (void)showBackAlert
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"功能" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"删除当前章节缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.viewModel deleteChapterSave];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"删除书本章节缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.viewModel deleteBookChapterSave];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)naviLeftBarItemClick
{
    if (![self.navigationController popViewControllerAnimated:YES]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)naviRightBarItemClick
{
    BookSourceListVC* vc = [[BookSourceListVC alloc] initWithModel:[self.viewModel getBookInfoModel]];
    vc.block = ^{
        [self.viewModel startInit];
    };
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)showMulu
{
    if (!self.chapterView.isShowMulu){
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.toolbarHidden = YES;
        
        self.chapterView.currentIndex = [self.viewModel getCurrentChapterIndex];
        self.chapterView.bookName = [self.viewModel getBookName];
        self.chapterView.chapters = [self.viewModel getAllChapters];
    }
    
    self.settingView.hidden = YES;
    self.chapterView.isShowMulu = !self.chapterView.isShowMulu;
}

- (void)showSettingView
{
    self.settingView.hidden = !self.settingView.hidden;
}

- (void)changeNightStyle
{
    BOOL isNight = HYUserDefault.isNightStyle;
    
    if (isNight){
        [self.nightView changeImageName:@"toolbar_night" Title:@"夜间"];
    }else{
        [self.nightView changeImageName:@"toolbar_day" Title:@"白天"];
    }
    
    HYUserDefault.isNightStyle = !isNight;
    [self.viewModel reloadContentViews];
}

- (void)changeNaviBarHidenWithAnimated
{
    self.settingView.hidden = YES;
    if (self.navigationController.navigationBarHidden){
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.toolbarHidden = NO;
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.toolbarHidden = YES;
    }
}

- (void)hidenNaviBar
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.toolbarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

/* 章节数据加载成功*/
- (void)loadDataSuccess:(UIViewController*)currentVC
{
    [MBProgressHUD hideHUDForView:self.view];
    
    NSArray *viewControllers = [NSArray arrayWithObject:currentVC];
    
    [_pageViewController.view removeFromSuperview];
    _pageViewController = [[BookPageVC alloc] initWithTransitionStyle:HYUserDefault.PageTransitionStyle navigationOrientation:HYUserDefault.PageNaviOrientation options:nil];
    
    kWeakSelf(self);
    _pageViewController.block = ^{
        kStrongSelf(self);
        [self changeNaviBarHidenWithAnimated];
    };
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    /* 通过双面显示,解决UIPageViewController仿真翻页时背面发白的问题*/
    _pageViewController.doubleSided = HYUserDefault.PageTransitionStyle==UIPageViewControllerTransitionStylePageCurl?YES:NO;
    
    _pageViewController.view.backgroundColor = HYUserDefault.readBackColor?:UIHexColor(0xa39e8b);
    
    
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:NO
                                     completion:nil];
    
    [self.view insertSubview:_pageViewController.view atIndex:0];
}

/* 章节数据加载失败*/
- (void)loadDataFail
{
    [MBProgressHUD hideHUDForView:self.view];
    [MBProgressHUD showError:@"章节加载失败" toView:self.view];
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    BOOL isDouble = HYUserDefault.PageTransitionStyle==UIPageViewControllerTransitionStylePageCurl?YES:NO;
    return [self.viewModel viewControllerBeforeViewController:viewController DoubleSided:isDouble];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    BOOL isDouble = HYUserDefault.PageTransitionStyle==UIPageViewControllerTransitionStylePageCurl?YES:NO;
    return [self.viewModel viewControllerAfterViewController:viewController DoubleSided:isDouble];
}

#pragma mark - lazyLoad
-(UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[BookPageVC alloc] initWithTransitionStyle:HYUserDefault.PageTransitionStyle navigationOrientation:HYUserDefault.PageNaviOrientation options:nil];
        
        kWeakSelf(self);
        _pageViewController.block = ^{
            kStrongSelf(self);
            [self changeNaviBarHidenWithAnimated];
        };
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        _pageViewController.doubleSided = HYUserDefault.PageTransitionStyle==UIPageViewControllerTransitionStylePageCurl?YES:NO;
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return self.navigationController.navigationBarHidden;
}

@end
