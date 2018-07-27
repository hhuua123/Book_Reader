//
//  BookSourceListVC.m
//  Book_Reader
//
//  Created by hhuua on 2018/7/23.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookSourceListVC.h"
#import "UIImage+Color.h"
#import "HYDatabase.h"
#import "HYBookAPIs.h"
#import "BooksourceModel.h"

@interface BookSourceListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* dataArray;
@property (nonatomic,strong) HYDatabase* database;
@property (nonatomic,strong) HYBookAPIs* bookApi;

@end

@implementation BookSourceListVC
- (instancetype)initWithModel:(BookInfoModel*)model
{
    self = [super init];
    if (self){
        self.mode = model;
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

- (void)initialNavi
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"navi_backbtnImage_white") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClick)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@书源",_mode.book_name];
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
    self.database = [HYDatabase sharedDatabase];
    self.bookApi = [[HYBookAPIs alloc] init];
    
    BookInfoModel* dbModel = [self.database selectBookInfoWithRelatedId:self.mode.related_id];
    if (!dbModel){
        [MBProgressHUD showError:@"加入书架后才能开启换源功能~" toView:self.view];
        return;
    }
    
    [MBProgressHUD showMessage:@"书源搜索中" toView:self.view];
    [self.bookApi searchBookSourceWithRelatedId:_mode.related_id Success:^(NSArray<BooksourceModel *> *models) {
        [MBProgressHUD hideHUDForView:self.view];
        self.dataArray = [NSMutableArray arrayWithArray:models];
        [self.tableView reloadData];
    } Fail:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"书源搜索错误" toView:self.view];
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"source_cell"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"source_cell"];
    }
    
    BooksourceModel* model = self.dataArray[indexPath.row];
    if ([model.source_name isEqualToString:_mode.source_name]){
        cell.textLabel.text = [NSString stringWithFormat:@"%@(当前源)",model.source_name];
        cell.textLabel.textColor = [UIColor redColor];
    }
    else{
        cell.textLabel.text = model.source_name;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"最新章节:%@",model.book_last_chapter];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BooksourceModel* model = self.dataArray[indexPath.row];
    if ([model.source_name isEqualToString:_mode.source_name])
        [self leftBarItemClick];
    else{
        [self.database updateBookSourceWithRelatedId:_mode.related_id Name:model.source_name SourceUrl:model.book_url];
        if (self.block){
            self.block();
        }
        [self leftBarItemClick];
    }
}


@end
