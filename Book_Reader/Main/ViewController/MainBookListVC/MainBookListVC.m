//
//  MainBookListVC.m
//  Book_Reader
//
//  Created by hhuua on 2018/7/3.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "MainBookListVC.h"
#import "MainBookInfoCell.h"
#import "UIImage+Color.h"
#import "HYDatabase.h"
#import "BookReadAPIVM.h"
#import "BookReadVC.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "HYBookAPIs.h"
#import "BookInfoVC.h"
#import <AFNetworking/AFNetworking.h>

@interface MainBookListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) HYDatabase* database;
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* dataArray;
@property (nonatomic,strong) HYBookAPIs* bookApi;
@end

@implementation MainBookListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavi];
    [self initialSubViews];
    [self initialData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)initialNavi
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIHexColor(0xa60014)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    UIBarButtonItem* right = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"main_showright") style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
    
    self.navigationItem.title = @"书架";
}

- (void)initialSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:kRegisterNib(@"MainBookInfoCell") forCellReuseIdentifier:@"MainBookInfoCell"];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
}

- (void)initialData
{
    self.database = [HYDatabase sharedDatabase];
    self.bookApi = [[HYBookAPIs alloc] init];
}

- (void)reloadData
{
    NSArray* arr = [self.database selectSaveBookInfos];
    self.dataArray = [NSMutableArray arrayWithArray:arr];
    
    [self.tableView reloadData];
}

- (void)rightItemClick
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)deleteBookInfoWithIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"确定删除书本吗?" message:@"该书的阅读记录将被保存一段时间,重新添加该书可以继续阅读。" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        BookSaveInfoModel* model = self.dataArray[indexPath.row];
        
        [self.database deleteSaveBookInfoWith:model];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainBookInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MainBookInfoCell"];
    
    BookSaveInfoModel* model = self.dataArray[indexPath.row];
    [cell setModel:model];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookSaveInfoModel* model = self.dataArray[indexPath.row];
    BookReadAPIVM* vm = [[BookReadAPIVM alloc] initWithBookModel:model.bookInfo];
    BookReadVC* vc = [[BookReadVC alloc] init];
    vc.viewModel = vm;
    
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self pushPresentWithOutSwipeViewController:navi];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookSaveInfoModel* model = self.dataArray[indexPath.row];
    
    UITableViewRowAction* ac1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteBookInfoWithIndexPath:indexPath];
    }];
    ac1.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction* ac2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"详情" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [MBProgressHUD showMessage:@"书本详情获取中" toView:self.view];
        
        [self.bookApi searchBookInfoWithRela_id:model.bookInfo.related_id Success:^(BookInfoModel *book) {
            [MBProgressHUD hideHUDForView:self.view];
            BookInfoVC* vc = [[BookInfoVC alloc] initWithModel:book];
            UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
            
            [self pushPresentViewController:navi];
        } Fail:^(NSError *err) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"书本详情获取失败" toView:self.view];
        }];
    }];
    ac2.backgroundColor = UIHexColor(0x008B8B);
    
    
    return @[ac1, ac2];
}

@end
