//
//  BookSearchVC.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/28.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookSearchVC.h"
#import "UIImage+Color.h"
#import "HYBookAPIs.h"
#import "HYDatabase.h"
#import "BookSearchHotView.h"
#import "UIButton+TouchAreaInsets.h"
#import "BookSearchListVC.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

#define kSearchDelay 0.05

@interface BookSearchVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
/* 搜索"框"*/
@property (nonatomic,strong) UITextField* searchTextField;
@property (nonatomic,strong) UIView* searchBackView;
@property (nonatomic,strong) UIButton* cancleBtn;
@property (nonatomic,strong) dispatch_source_t search_t;
/* 搜索热词*/
@property (nonatomic,strong) BookSearchHotView* hotView;
@property (nonatomic,strong) UIView* hotTitleView;
@property (nonatomic,strong) UILabel* hotTitleLabel;
/* 搜索历史*/
@property (nonatomic,strong) UIView* historyView;
@property (nonatomic,strong) UILabel* historyLabel;
@property (nonatomic,strong) UIButton* deleteBtn;
@property (nonatomic,strong) UITableView* historyTBV;
@property (nonatomic,strong) NSArray* historyArr;
/* 书名展示tableView*/
@property (nonatomic,strong) UITableView* bookNamesTBV;
@property (nonatomic,strong) NSArray* bookNameArr;

@property (nonatomic,strong) HYBookAPIs* bookApi;
@property (nonatomic,strong) HYDatabase* database;

@end

@implementation BookSearchVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [self initialNavi];
    [self initialSubViews];
    [self initialSubViewConstraints];
    [self initialData];
}

- (void)initialNavi
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIHexColor(0xa60014)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}

- (void)initialSubViews
{
    _searchBackView = [[UIView alloc] init];
    _searchBackView.backgroundColor = [UIColor whiteColor];
    _searchBackView.layer.cornerRadius = 3;
    _searchBackView.clipsToBounds = YES;
    [self.navigationController.view addSubview:_searchBackView];
    
    _searchTextField = [[UITextField alloc] init];
    [_searchTextField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
    _searchTextField.placeholder = @"请输入书名以搜索";
    _searchTextField.delegate = self;
    _searchTextField.font = [UIFont systemFontOfSize:14];
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.backgroundColor = [UIColor whiteColor];
    [self.searchBackView addSubview:_searchTextField];
    
    _cancleBtn = [[UIButton alloc] init];
    [_cancleBtn addTarget:self action:@selector(cancleSearch) forControlEvents:UIControlEventTouchUpInside];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancleBtn.titleLabel.textColor = [UIColor whiteColor];
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navigationController.view addSubview:_cancleBtn];
    
    _hotView = [[BookSearchHotView alloc] init];
    _hotView.frame = CGRectMake(0, 30, kScreenWidth, 140);
    /* 搜索热词被点击*/
    kWeakSelf(self);
    _hotView.selectBlock = ^(NSString *title) {
        kStrongSelf(self);
        [self.database saveSearchHistoryWithName:title];
        [self reloadHistoryTBV];
        [self pushToBookListVCWithKeyWord:title];
    };
    [self.view addSubview:_hotView];
    
    _hotTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    _hotTitleView.backgroundColor = UIHexColor(0xedeeef);
    [self.view addSubview:_hotTitleView];
    
    _hotTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 120, 20)];
    _hotTitleLabel.font = [UIFont systemFontOfSize:12];
    _hotTitleLabel.text = @"搜索热词";
    _hotTitleLabel.textColor = UIHexColor(0x9e9e9e);
    [self.hotTitleView addSubview:_hotTitleLabel];
    
    _historyView = [[UIView alloc] init];
    _historyView.backgroundColor = UIHexColor(0xedeeef);
    [self.view addSubview:_historyView];
    
    _historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 120, 20)];
    _historyLabel.font = [UIFont systemFontOfSize:12];
    _historyLabel.text = @"搜索历史";
    _historyLabel.textColor = UIHexColor(0x9e9e9e);
    [self.historyView addSubview:_historyLabel];
    
    _deleteBtn = [[UIButton alloc] init];
    _deleteBtn.touchAreaInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [_deleteBtn addTarget:self action:@selector(deleteAllSearchHistory) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setImage:kGetImage(@"delete") forState:UIControlStateNormal];
    [self.historyView addSubview:_deleteBtn];
    
    _historyTBV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _historyTBV.delegate = self;
    _historyTBV.dataSource = self;
    _historyTBV.separatorColor = [UIColor clearColor];
    [self.view addSubview:_historyTBV];
    
    _bookNamesTBV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _bookNamesTBV.delegate = self;
    _bookNamesTBV.dataSource = self;
    _bookNamesTBV.separatorColor = [UIColor clearColor];
    [self.view addSubview:_bookNamesTBV];
    _bookNamesTBV.hidden = YES;
}

- (void)initialSubViewConstraints
{
    [_searchBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(28);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.cancleBtn.mas_left).offset(-8);
    }];
    
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.width.mas_equalTo(35);
        make.centerY.equalTo(self.searchBackView.mas_centerY);
    }];
    
    [_bookNamesTBV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [_historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.hotView.mas_bottom);
        make.height.mas_equalTo(35);
    }];
    
    [_historyTBV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.historyView.mas_bottom);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.historyView);
        make.right.mas_equalTo(-20);
    }];
}

- (void)initialData
{
    self.bookApi = [[HYBookAPIs alloc] init];
    self.database = [HYDatabase sharedDatabase];
    
    /* 加载搜索热词*/
    if (HYUserDefault.hotWordArr){
        self.hotView.historyWordsArr = [NSArray arrayWithArray:HYUserDefault.hotWordArr];
    }
    [self.bookApi searchHotBookWithSuccess:^(NSArray<NSString *> *names) {
        self.hotView.historyWordsArr = [NSArray arrayWithArray:names];
        HYUserDefault.hotWordArr = [NSArray arrayWithArray:names];
    } Fail:^(NSError *err) {
        
    }];
    
    /* 更新搜索历史*/
    [self reloadHistoryTBV];
}

- (void)reloadHistoryTBV
{
    NSArray* hisArr = [self.database selectSearchHistorys];
    self.historyArr = [NSArray arrayWithArray:hisArr];
    [self.historyTBV reloadData];
}

- (void)searchBook
{
    /* 根据输入内容进行相关书名查找*/
    if (!kStringIsEmpty(self.searchTextField.text)){
        self.bookNameArr = [NSArray array];
        [self.bookNamesTBV reloadData];
        
        
        [self.bookApi searchBookNamesWithKeyWord:self.searchTextField.text Success:^(NSArray<NSDictionary *> *names) {
            if(!self.bookNamesTBV.hidden){
                
                self.bookNameArr = [NSArray arrayWithArray:names];
                [self.bookNamesTBV reloadData];
            }
        } Fail:^(NSError *err) {
            
        }];
    }
}

- (void)textFieldChange
{
    self.bookNamesTBV.hidden = self.searchTextField.text.length<1;
    
    /* 进行一个函数调用防抖动处理,以避免过于频繁的调用搜索功能*/
    if (_search_t){
        dispatch_source_cancel(_search_t);
    }
    
    _search_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_search_t, dispatch_time(DISPATCH_TIME_NOW, kSearchDelay * NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 0);
    dispatch_source_set_event_handler(_search_t, ^{
        [self searchBook];
    });
    
    dispatch_resume(_search_t);
}

- (void)deleteAllSearchHistory
{
    [self.database deleteAllSearch];
    [self reloadHistoryTBV];
}

- (void)pushToBookListVCWithKeyWord:(NSString*)kw
{
    if (!kStringIsEmpty(kw)){
        BookSearchListVC* vc = [[BookSearchListVC alloc] initWithKeyWord:kw];
        UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [self pushPresentViewController:navi];
    }
}

- (void)pushToBookListVCWithAuthor:(NSString*)author
{
    if (!kStringIsEmpty(author)){
        BookSearchListVC* vc = [[BookSearchListVC alloc] initWithAuthorName:author];
        UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [self pushPresentViewController:navi];
    }
}

#pragma mark - target
- (void)cancleSearch
{
    if (![self.navigationController popViewControllerAnimated:YES]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (!kStringIsEmpty(textField.text)){
        [self.database saveSearchHistoryWithName:textField.text];
        [self pushToBookListVCWithKeyWord:textField.text];
        return YES;
    }
    
    return NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.bookNamesTBV){
        return self.bookNameArr.count;
    }
    return self.historyArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.bookNamesTBV){
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"titleCell"];
        }
        NSDictionary* dic = self.bookNameArr[indexPath.row];
        NSString* name = dic[@"name"];
        
        if ([dic[@"type"] isEqualToString:@"author"]){
            cell.imageView.image = kGetImage(@"author");
            
            NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  作者 ",name] attributes:nil];
            
            [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(name.length + 1, 4)];
            [attStr addAttribute:NSBackgroundColorAttributeName value:UIHexColor(0xf6a34f) range:NSMakeRange(name.length + 1, 4)];
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(name.length + 1, 4)];
            
            cell.textLabel.attributedText = attStr;
        }else{
            cell.imageView.image = kGetImage(@"book");
            cell.textLabel.text = name;
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"historyCell"];
    }
    cell.textLabel.text = self.historyArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.bookNamesTBV){
        return 35;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.bookNamesTBV){
        NSDictionary* dic = self.bookNameArr[indexPath.row];
        [self.database saveSearchHistoryWithName:dic[@"name"]];
        [self reloadHistoryTBV];
        
        if ([dic[@"type"] isEqualToString:@"author"]){
            [self pushToBookListVCWithAuthor:dic[@"name"]];
        }else{
            [self pushToBookListVCWithKeyWord:dic[@"name"]];
        }
        
    }else{
        [self.database saveSearchHistoryWithName:self.historyArr[indexPath.row]];
        [self pushToBookListVCWithKeyWord:self.historyArr[indexPath.row]];
    }
    
}

#pragma mark - Status
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

@end
