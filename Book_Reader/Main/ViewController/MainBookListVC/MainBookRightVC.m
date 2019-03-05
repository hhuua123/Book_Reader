//
//  MainBookRightVC.m
//  Book_Reader
//
//  Created by hhuua on 2018/7/3.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "MainBookRightVC.h"
#import "MainBookRightCell.h"
#import "BookSearchVC.h"
#import "BookSortVC.h"
#import "HYBookAPIs.h"
#import "BookReadAPIVM.h"
#import "BookReadVC.h"
#import "UnsplashImageVC.h"

@interface MainBookRightVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) HYBookAPIs* bookApi;
@end

@implementation MainBookRightVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSubViews];
    [self initialData];
}

- (void)initialSubViews
{
    self.view.backgroundColor = UIHexColor(0x1b1b1b);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = UIHexColor(0x1b1b1b);
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.backgroundColor = UIHexColor(0x1b1b1b);
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:kRegisterNib(@"MainBookRightCell") forCellReuseIdentifier:@"MainBookRightCell"];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(40);
    }];
}

- (void)initialData
{
    self.bookApi = [[HYBookAPIs alloc] init];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainBookRightCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MainBookRightCell"];
    
    switch (indexPath.row) {
        case 0:
            [cell changeBackColor:[UIColor whiteColor] Image:kGetImage(@"main_search") Name:@"搜索"];
            break;
        case 1:
            [cell changeBackColor:UIHexColor(0xff0035) Image:kGetImage(@"main_paihang") Name:@"排行榜"];
            break;
        case 2:
            [cell changeBackColor:UIHexColor(0x40b0df) Image:kGetImage(@"main_fenlei") Name:@"分类"];
            break;
        case 3:
            [cell changeBackColor:UIHexColor(0x679f37) Image:kGetImage(@"main_random") Name:@"随机看书"];
            break;
        case 4:
            [cell changeBackColor:UIHexColor(0xff0035) Image:kGetImage(@"main_unsplash ") Name:@"unsplash"];
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    if (indexPath.row==0){
        BookSearchVC* vc = [[BookSearchVC alloc] init];
        UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [self pushPresentViewController:navi];
    }else if (indexPath.row==2){
        BookSortVC* vc = [[BookSortVC alloc] init];
        UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [self pushPresentViewController:navi];
    }else if (indexPath.row==3){
        [MBProgressHUD showMessage:@"随机找书中~" toView:self.view];
        [self.bookApi randomSearchBookInfoWithSuccess:^(BookInfoModel *book) {
            [MBProgressHUD hideHUDForView:self.view];
            
            BookReadAPIVM* vm = [[BookReadAPIVM alloc] initWithBookModel:book];
            BookReadVC* vc = [[BookReadVC alloc] init];
            vc.viewModel = vm;
            
            UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
            [self pushPresentWithOutSwipeViewController:navi];
            
        } Fail:^(NSError *err) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"没找到书~再试一下" toView:self.view];
        }];
    }else if (indexPath.row==4){
        UnsplashImageVC* vc = [[UnsplashImageVC alloc] init];
        UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [self pushPresentViewController:navi];
    }
    
}

@end
