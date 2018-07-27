//
//  BookSortVC.m
//  Book_Reader
//
//  Created by hhuua on 2018/7/20.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookSortVC.h"
#import "UIImage+Color.h"
#import "HYBookAPIs.h"
#import "BookSearchListVC.h"

@interface BookSortVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) HYBookAPIs* bookAPI;
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSArray* dataArr;
@end

@implementation BookSortVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavi];
    [self initialSubViews];
    [self initialData];
}

- (void)initialNavi
{
    self.navigationItem.title = @"分类";
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIHexColor(0xa60014)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"navi_backbtnImage_white") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClick)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initialSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)initialData
{
    self.bookAPI = [[HYBookAPIs alloc] init];
    
    [MBProgressHUD showMessage:@"搜索中" toView:self.view];
    
    [self.bookAPI searchBookSortWithSuccess:^(NSArray<NSDictionary *> *array) {
        [MBProgressHUD hideHUDForView:self.view];
        self.dataArr = [NSArray arrayWithArray:array];
        [self.tableView reloadData];
    } Fail:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"搜索错误" toView:self.view];
    }];
}

#pragma mark - target
- (void)leftBarItemClick
{
    if (![self.navigationController popViewControllerAnimated:YES]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"sort_cell"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"sort_cell"];
    }
    
    if (indexPath.row<self.dataArr.count){
        NSDictionary* dic = self.dataArr[indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"book_sort"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld本",[[dic objectForKey:@"sort_count"] integerValue]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<self.dataArr.count){
        NSDictionary* dic = self.dataArr[indexPath.row];
        NSString* sort = [dic objectForKey:@"book_sort"];
        
        BookSearchListVC* vc = [[BookSearchListVC alloc] initWithSortName:sort];
        UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [self pushPresentViewController:navi];
    }
}

@end
