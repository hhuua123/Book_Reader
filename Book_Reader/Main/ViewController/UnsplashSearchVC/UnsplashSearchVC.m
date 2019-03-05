//
//  UnsplashSearchVC.m
//  Book_Reader
//
//  Created by hhuua on 2019/3/5.
//  Copyright © 2019 hhuua. All rights reserved.
//

#import "UnsplashSearchVC.h"
#import "HYFlowLayout.h"
#import <MJRefresh/MJRefresh.h>
#import "UnsplashAPI.h"
#import "UnsplashImageCell.h"
#import "HYHigherOrderFunc.h"

@interface UnsplashSearchVC ()<UISearchBarDelegate,UISearchResultsUpdating,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView* collectionView;
@property (nonatomic,strong) NSArray* dataArr;
@property (nonatomic,strong) HYFlowLayout* layout;
@property (nonatomic,strong) UnsplashAPI* unsplashApi;
@property (nonatomic,copy) NSString* keyWord;
@property (nonatomic,assign) BOOL isEnd;
@property (nonatomic,assign) BOOL isLoad;

@end

@implementation UnsplashSearchVC

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self initSubView];
}

- (void)loadView
{
    [super loadView];
    
    self.searchResultsUpdater = self;
    self.searchBar.delegate = self;
}

- (void)reloadView
{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    self.dataArr = [NSArray array];
    
    [self.collectionView reloadData];
    _keyWord = @"";
}

- (void)initSubView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _layout                         = [[HYFlowLayout alloc] init];
    _layout.colCount                = 2;
    _layout.itemMinHeight           = 40;
    _layout.edgeInsets              = UIEdgeInsetsMake(10, 0, 0, 0);
    _layout.minimumLineSpacing      = 10;
    _layout.minimumInteritemSpacing = 10;
    
    _collectionView                 = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
    _collectionView.dataSource      = self;
    _collectionView.delegate        = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.mj_header       = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadSearchData)];
    
    _collectionView.mj_footer       = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextSearchData)];
    [_collectionView registerNib:kRegisterNib(@"UnsplashImageCell") forCellWithReuseIdentifier:@"UnsplashImageCell"];
    [self.view addSubview:_collectionView];

    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(60);
    }];
}

- (void)reloadSearchData
{
    if (self.isLoad)
        return;
    
    _keyWord = self.searchBar.text;
    
    self.isLoad = YES;
    [self.unsplashApi searchImageListWithKeyWord:_keyWord page:1 success:^(NSArray<UnsplashImageModel *> *images, NSInteger page) {
        [self.collectionView.mj_header endRefreshing];
        self.dataArr = [NSArray arrayWithArray:images];
        self.layout.sizeList = kMap(self.dataArr, ^id(UnsplashImageModel* obj) {
            return [NSValue valueWithCGSize:CGSizeMake(obj.width, obj.height)];
        });
        self.isEnd = images.count < 30? YES:NO;
        
        self.isLoad = NO;
        [self.collectionView reloadData];
        
    } Fail:^(NSError *error) {
        self.isLoad = NO;
        [MBProgressHUD showError:@"加载错误" toView:self.view];
    }];
    
}

- (void)loadNextSearchData
{
    if (self.dataArr.count == 0 || self.isLoad)
        return;
    
    _keyWord = self.searchBar.text;
    
    NSInteger page = floor(self.dataArr.count / 30) + 1;
    self.isLoad = YES;
    [self.unsplashApi searchImageListWithKeyWord:_keyWord page:page success:^(NSArray<UnsplashImageModel *> *images, NSInteger page) {
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
    } Fail:^(NSError *error) {
        self.isLoad = NO;
        [MBProgressHUD showError:@"加载错误" toView:self.view];
    }];
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
            [self loadNextSearchData];
        }
    }
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if ([self.keyWord isEqualToString:searchBar.text] || kStringIsEmpty(searchBar.text))
        return;
    
    if (self.collectionView.mj_header.isRefreshing)
        [self.collectionView.mj_header endRefreshing];
    
    [self.collectionView.mj_header beginRefreshing];
    
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
