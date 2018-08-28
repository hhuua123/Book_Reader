//
//  BookInfoVC.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/29.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookInfoVC.h"
#import "UIImage+Color.h"
#import "BookInfoModel.h"
#import "BookReadVC.h"
#import "BookReadAPIVM.h"
#import "HYDatabase.h"
#import "HYBookAPIs.h"
#import "BookSearchListVC.h"
#import <YYWebImage/YYWebImage.h>

@interface BookInfoVC ()
@property (nonatomic,strong) BookInfoModel* model;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastLabel;
@property (nonatomic,strong) HYDatabase* database;
@property (nonatomic,strong) HYBookAPIs* bookApi;

@property (weak, nonatomic) IBOutlet UIButton *addBookBtn;

@end

@implementation BookInfoVC

- (instancetype)initWithModel:(BookInfoModel*)model
{
    self = [super init];
    if (self){
        _model = model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavi];
    [self initialData];
}

- (void)initialNavi
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIHexColor(0xa60014)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"navi_backbtnImage_white") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClick)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    
    self.navigationItem.title = self.model.book_name;
}

- (void)initialData
{
    self.bookApi = [[HYBookAPIs alloc] init];
    self.database = [HYDatabase sharedDatabase];
    

    
    [_imageV yy_setImageWithURL:[NSURL URLWithString:_model.book_image] placeholder:nil options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (error){
            [self.imageV setImage:kGetImage(@"placeholder_empty")];
        }
    }];
    
    _authorLabel.text = _model.author;
    _nameLabel.text = _model.book_name;
    _sortLabel.text = [NSString stringWithFormat:@"类型:%@",_model.book_sort];
    _wordLabel.text = [NSString stringWithFormat:@"%.0lf万字 | %@",_model.book_word_count/10000.0,_model.book_state];
    _descriptionLabel.text = _model.book_desc;
    _lastLabel.text = _model.book_last_chapter;
    
    [self changeBookSaveStatus];
}

- (void)changeBookSaveStatus
{
    BookInfoModel* model = [self.database selectBookInfoWithRelatedId:self.model.related_id];
    if (model){
        [self.addBookBtn setTitle:@"- 不追了" forState:UIControlStateNormal];
        [self.addBookBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        [self.addBookBtn setTitle:@"+ 追更新" forState:UIControlStateNormal];
        [self.addBookBtn setTitleColor:UIHexColor(0xD82626) forState:UIControlStateNormal];
    }
}

- (void)removeBookModel
{
    [self.database deleteBookInfoWithRelatedId:self.model.related_id];
}

- (void)addBookModel
{
    [self.database saveBookInfoWithModel:self.model];
    
    /* 添加书本章节缓存*/
    if ([self.database selectChapterWithSourceUrl:self.model.book_url].count == 0)
        [self.bookApi chapterListWithBook:self.model Success:nil Fail:nil];
}

#pragma mark - target
- (IBAction)addBookBtnClick:(UIButton *)sender
{
    BookInfoModel* model = [self.database selectBookInfoWithRelatedId:self.model.related_id];
    if (model){
        [self removeBookModel];
    }else{
        [self addBookModel];
    }
    [self changeBookSaveStatus];
}

- (void)leftBarItemClick
{
    if (![self.navigationController popViewControllerAnimated:YES]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/* 开始阅读按钮被点击*/
- (IBAction)startReadClick:(UIButton *)sender
{
    BookReadAPIVM* vm = [[BookReadAPIVM alloc] initWithBookModel:self.model];
    BookReadVC* vc = [[BookReadVC alloc] init];
    vc.viewModel = vm;
    
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self pushPresentViewController:navi];
}

- (IBAction)authorLabelClick:(UITapGestureRecognizer *)sender
{
    if ([_model.author isEqualToString:_author]){
        [self leftBarItemClick];
    }else{
        BookSearchListVC* vc = [[BookSearchListVC alloc] initWithAuthorName:_model.author];
        UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [self pushPresentViewController:navi];
    }
}


@end
