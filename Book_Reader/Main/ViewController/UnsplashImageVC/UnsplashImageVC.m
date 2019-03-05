//
//  UnsplashImageVC.m
//  Book_Reader
//
//  Created by hhuua on 2019/3/4.
//  Copyright © 2019 hhuua. All rights reserved.
//

#import "UnsplashImageVC.h"
#import "HYFlowLayout.h"
#import "UnsplashImageCell.h"
#import "UnsplashAPI.h"
#import "HYHigherOrderFunc.h"
#import "UIImage+Color.h"
#import <MJRefresh/MJRefresh.h>
#import "UnsplashSearchVC.h"

@interface UnsplashImageVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchControllerDelegate>
@property (nonatomic,strong) UICollectionView* collectionView;
@property (nonatomic,strong) NSArray* dataArr;
@property (nonatomic,strong) HYFlowLayout* layout;
@property (nonatomic,strong) UnsplashAPI* unsplashApi;
@property (nonatomic,strong) UnsplashSearchVC* searchVC;
@property (nonatomic,assign) BOOL isEnd;
@property (nonatomic,assign) BOOL isLoad;

@end

@implementation UnsplashImageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavi];
    [self initSubView];
    
    if (!_collectionView.mj_header.isRefreshing){
        [_collectionView.mj_header beginRefreshing];
    }
}

- (void)initialNavi
{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIHexColor(0xffffff)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.navigationItem.title = @"今日精选";
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"navi_backbtnImage_white") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClick)];
    item.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initSubView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _layout                         = [[HYFlowLayout alloc] init];
    _layout.colCount                = 2;
    _layout.itemMinHeight           = 40;
    _layout.edgeInsets              = UIEdgeInsetsMake(10, 0, 0, 0);
    _layout.headerSize              = CGSizeMake(kScreenWidth, 50);
    _layout.minimumLineSpacing      = 10;
    _layout.minimumInteritemSpacing = 10;
    
    _collectionView                 = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
    _collectionView.dataSource      = self;
    _collectionView.delegate        = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.mj_header       = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadImageData)];
    _collectionView.mj_footer       = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    
    [_collectionView registerNib:kRegisterNib(@"UnsplashImageCell") forCellWithReuseIdentifier:@"UnsplashImageCell"];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    /* 搜索界面*/
    _searchVC = [[UnsplashSearchVC alloc] initWithSearchResultsController:nil];
    _searchVC.searchBar.barTintColor = UIHexColor(0xefeff4);
    _searchVC.searchBar.tintColor = UIHexColor(0x2ec72d);
    _searchVC.searchBar.backgroundColor = [UIColor lightGrayColor];
    _searchVC.delegate = self;
    UIImageView *barImageView = [[[_searchVC.searchBar.subviews firstObject] subviews] firstObject];
    barImageView.layer.borderColor = UIHexColor(0xefeff4).CGColor;
    barImageView.layer.borderWidth = 1;
}

- (void)loadNextData
{
    if (self.dataArr.count == 0 || self.isLoad)
        return;
    
    NSInteger page = floor(self.dataArr.count / 30) + 1;
    self.isLoad = YES;
    [self.unsplashApi getImageListWithPage:page success:^(NSArray<UnsplashImageModel *> * _Nonnull images, NSInteger page) {
        [self.collectionView.mj_footer endRefreshing];
        
        NSMutableArray* nArr = [NSMutableArray arrayWithArray:self.dataArr];
        [nArr addObjectsFromArray:images];
        
        self.dataArr = [NSArray arrayWithArray:nArr];
        self.layout.sizeList = kMap(self.dataArr, ^id(UnsplashImageModel* obj) {
            return [NSValue valueWithCGSize:CGSizeMake(obj.width, obj.height)];
        });
        
        self.isEnd = images.count < 30? YES:NO;
        
        self.isLoad = NO;
        [self.collectionView reloadData];
        
    } Fail:^(NSError * _Nonnull error) {
        self.isLoad = NO;
        [MBProgressHUD showError:@"加载错误" toView:self.view];
    }];
}

#pragma mark - target
/* 从第一页开始重新刷新*/
- (void)reloadImageData
{
    if (self.isLoad)
        return;
    
    self.isLoad = YES;
    [self.unsplashApi getImageListWithPage:1 success:^(NSArray<UnsplashImageModel *> * _Nonnull images, NSInteger page) {
        [self.collectionView.mj_header endRefreshing];
        
        self.dataArr = [NSArray arrayWithArray:images];
        self.layout.sizeList = kMap(self.dataArr, ^id(UnsplashImageModel* obj) {
            return [NSValue valueWithCGSize:CGSizeMake(obj.width, obj.height)];
        });
        self.isEnd = images.count < 30? YES:NO;
        
        self.isLoad = NO;
        [self.collectionView reloadData];
    } Fail:^(NSError * _Nonnull error) {
        self.isLoad = NO;
        [MBProgressHUD showError:@"加载错误" toView:self.view];
    }];
}

- (void)leftBarItemClick
{
    if (![self.navigationController popViewControllerAnimated:YES]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController
{
    self.navigationController.navigationBar.translucent = YES;
    [self.searchVC reloadView];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    self.navigationController.navigationBar.translucent = NO;
    [self.searchVC reloadView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UnsplashImageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UnsplashImageCell" forIndexPath:indexPath];
    UnsplashImageModel* model = self.dataArr[indexPath.row];
    [cell setModel:model];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        
        reusableview.backgroundColor = [UIColor whiteColor];
        [reusableview addSubview:self.searchVC.searchBar];
        return reusableview;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /* 加载错误时,重新加载*/
    UnsplashImageCell* cell = (UnsplashImageCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if ([cell reloadImage])
        return;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.frame.size.height + (kScreenHeight * 2);
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    if (distanceFromBottom < height) {
        if (!self.isEnd && !self.isLoad){
            [self.collectionView.mj_footer beginRefreshing];
            [self loadNextData];
        }
    }
}

#pragma mark - lazyload
- (UnsplashAPI *)unsplashApi
{
    if (!_unsplashApi){
        _unsplashApi = [[UnsplashAPI alloc] init];
    }
    return _unsplashApi;
}

@end
