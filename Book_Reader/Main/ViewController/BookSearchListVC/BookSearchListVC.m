//
//  BookSearchListVC.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/29.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookSearchListVC.h"
#import "UIImage+Color.h"
#import "HYBookAPIs.h"
#import "BookInfoCell.h"
#import "UIView+HYEmptyView.h"
#import "BookInfoVC.h"
#import <MJRefresh/MJRefresh.h>

typedef NS_ENUM(NSInteger, searchType) {
    searchTypeKeyWord = 0,
    searchTypeSortName,
    searchTypeAuthor,
};

@interface BookSearchListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,copy) NSString* keyWord;
@property (nonatomic,copy) NSString* sortName;
@property (nonatomic,copy) NSString* author;

@property (nonatomic,assign) searchType type;

@property (nonatomic,strong) HYBookAPIs* bookAPI;
@property (nonatomic,strong) NSMutableArray* dataArr;
@property (nonatomic,strong) UITableView* tableView;

@property (nonatomic,assign) BOOL isEnd;
@end

@implementation BookSearchListVC

- (instancetype)initWithKeyWord:(NSString*)kw
{
    self = [super init];
    if (self){
        self.keyWord = kw;
        self.type = searchTypeKeyWord;
    }
    return self;
}

- (instancetype)initWithSortName:(NSString*)sort
{
    self = [super init];
    if (self){
        self.sortName = sort;
        self.type = searchTypeSortName;
    }
    return self;
}

- (instancetype)initWithAuthorName:(NSString*)author
{
    self = [super init];
    if (self){
        self.author = author;
        self.type = searchTypeAuthor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavi];
    [self initialSubViews];
    [self initialData];
}

- (void)initialSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(searchBooks)];
    
    [_tableView registerNib:kRegisterNib(@"BookInfoCell") forCellReuseIdentifier:@"BookInfoCell"];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)initialNavi
{
    switch (self.type) {
        case searchTypeSortName:
            self.navigationItem.title = [NSString stringWithFormat:@"%@小说",self.sortName];
            break;
        case searchTypeKeyWord:
            self.navigationItem.title = self.keyWord;
            break;
        case searchTypeAuthor:
            self.navigationItem.title = [NSString stringWithFormat:@"%@作品",self.author];
            break;
        default:
            break;
    }
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIHexColor(0xa60014)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"navi_backbtnImage_white") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClick)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initialData
{
    self.isEnd = NO;
    self.dataArr = [NSMutableArray array];
    self.bookAPI = [[HYBookAPIs alloc] init];
    
    [self searchBooks];
}

- (void)searchBooks
{
    [self.view removeEmptyView];
    if (self.dataArr.count==0)
        [MBProgressHUD showMessage:@"搜索中!" toView:self.view];
    
    if (self.isEnd){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"已经没有更多了!" toView:self.view];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    
    switch (self.type) {
        case searchTypeAuthor:
            [self searchBookWithAuthor];
            break;
        case searchTypeKeyWord:
            [self searchBookWithKeyWord];
            break;
        case searchTypeSortName:
            [self searchBookWithSort];
            break;
            
        default:
            break;
    }
}

- (void)searchBookWithAuthor
{
    /* 作者搜索*/
    [self.bookAPI searchBookWithAuthor:self.author Start:self.dataArr.count Success:^(NSArray<BookInfoModel *> *books) {
        self.isEnd = books.count < 20;
        
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        [self.dataArr addObjectsFromArray:books];
        [self.tableView reloadData];
        
        if (self.dataArr.count==0){
            [self.view changeEmptyViewToNoDataWith:^{
                [self searchBooks];
            }];
        }
    } Fail:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"搜索失败" toView:self.view];
        
        if (self.dataArr.count==0){
            [self.view changeEmptyViewToNetErrorWith:^{
                [self searchBooks];
            }];
        }
       
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)searchBookWithSort
{
    /* 分类搜索*/
    [self.bookAPI searchBookWithSortName:self.sortName Start:self.dataArr.count Success:^(NSArray<BookInfoModel *> *books) {
        self.isEnd = books.count < 20;
        
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        [self.dataArr addObjectsFromArray:books];
        [self.tableView reloadData];
        
        if (self.dataArr.count==0){
            [self.view changeEmptyViewToNoDataWith:^{
                [self searchBooks];
            }];
        }
    } Fail:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"搜索失败" toView:self.view];
        
        if (self.dataArr.count==0){
            [self.view changeEmptyViewToNetErrorWith:^{
                [self searchBooks];
            }];
        }
        
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)searchBookWithKeyWord
{
    /* 关键词搜索*/
    [self.bookAPI searchBookWithKeyWord:self.keyWord Start:self.dataArr.count Success:^(NSArray<BookInfoModel *> *books) {
        self.isEnd = books.count < 20;
        
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        [self.dataArr addObjectsFromArray:books];
        [self.tableView reloadData];
        
        if (self.dataArr.count==0){
            [self.view changeEmptyViewToNoDataWith:^{
                [self searchBooks];
            }];
        }
    } Fail:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"搜索失败" toView:self.view];
        
        if (self.dataArr.count==0){
            [self.view changeEmptyViewToNetErrorWith:^{
                [self searchBooks];
            }];
        }
        
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BookInfoCell"];
    
    BookInfoModel* model = self.dataArr[indexPath.row];
    [cell setModel:model];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookInfoModel* model = self.dataArr[indexPath.row];
    BookInfoVC* vc = [[BookInfoVC alloc] initWithModel:model];
    if (self.type==searchTypeAuthor){
        vc.author = model.author;
    }
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self pushPresentViewController:navi];
}

#pragma mark - target
- (void)leftBarItemClick
{
    if (![self.navigationController popViewControllerAnimated:YES]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
