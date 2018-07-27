//
//  BookChapterView.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/28.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookChapterView.h"
#import "UIImage+Color.h"
#import "UIButton+TouchAreaInsets.h"

#define kMuluWidth kScreenWidth*0.8

@interface BookChapterView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIView* muluView;
@property (nonatomic,strong) UIImageView* imageV;
@property (nonatomic,strong) UILabel* bookNameLabel;
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) UILabel* titleLabel;
@property (nonatomic,strong) UIButton* button;
/* 是否倒序*/
@property (nonatomic,assign) BOOL isDescending;

@property (nonatomic,strong) NSArray* dataArray;
@end
@implementation BookChapterView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    CGRect setView = CGRectMake(kMuluWidth, 0, kScreenWidth - kMuluWidth, kScreenHeight);
    
    if (CGRectContainsPoint(setView,point)){
        self.isShowMulu = NO;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self initialSubViews];
    }
    return self;
}

- (void)initialSubViews
{
    self.backgroundColor = [UIColor clearColor];
    
    self.muluView = [[UIView alloc] initWithFrame:CGRectMake(-kMuluWidth, 0, kMuluWidth, kScreenHeight)];
    self.muluView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.muluView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 100, kMuluWidth - 8, kScreenHeight - 100) style:UITableViewStylePlain];
    self.tableView.separatorColor = UIHexColor(0xd3d3d3);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.muluView addSubview:self.tableView];
    
    self.bookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kMuluWidth - 40, 20)];
    self.bookNameLabel.font = [UIFont systemFontOfSize:17];
    self.bookNameLabel.text = self.bookName;
    [self.muluView addSubview:self.bookNameLabel];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 80, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.text = @"目录";
    [self.muluView addSubview:self.titleLabel];
    
    self.imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:UIHexColor(0xd3d3d3)]];
    self.imageV.frame = CGRectMake(0, 85, kMuluWidth, 0.2);
    [self.muluView addSubview:self.imageV];
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(kMuluWidth - 40, 60, 20, 20)];
    [self.button addTarget:self action:@selector(changeScending) forControlEvents:UIControlEventTouchUpInside];
    [self.button setImage:kGetImage(@"mulu_descending") forState:UIControlStateNormal];
    self.button.touchAreaInsets = UIEdgeInsetsMake(5, 5, 5, 10);
    [self.muluView addSubview:self.button];
}

- (void)setIsShowMulu:(BOOL)isShowMulu
{
    _isShowMulu = isShowMulu;
    if (isShowMulu){
        [self setNeedsLayout];
        self.width = kScreenWidth;
        
        [self.tableView reloadData];
        [self scrollToCurrentIndex];
        
        [UIView animateWithDuration:0.2 animations:^{
            [self setNeedsLayout];
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
            self.muluView.left = 0;
        }];
    }else{
        [self setNeedsLayout];
        self.width = 0;
        [UIView animateWithDuration:0.2 animations:^{
            [self setNeedsLayout];
            self.backgroundColor = [UIColor clearColor];
            self.muluView.left = -kMuluWidth;
        }];
    }
}

- (void)scrollToCurrentIndex
{
    if (!_isDescending){
        if (_chapters.count<=self.currentIndex){
            return;
        }
        
        NSIndexPath* index = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }else{
        if (_chapters.count<self.dataArray.count - self.currentIndex - 1){
            return;
        }
        
        NSIndexPath* index = [NSIndexPath indexPathForRow:self.dataArray.count - self.currentIndex - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)setBookName:(NSString *)bookName
{
    _bookName = bookName;
    
    self.bookNameLabel.text = _bookName;
}

- (void)setChapters:(NSArray<NSString *> *)chapters
{
    _chapters = chapters;
    
    if (_chapters.count==0){
        [MBProgressHUD showError:@"暂无章节信息"];
        [_tableView reloadData];
        return;
    }
    
    if (_isDescending){
        self.dataArray = [NSArray arrayWithArray:[[_chapters reverseObjectEnumerator] allObjects]];
    }else{
        self.dataArray = [NSArray arrayWithArray:_chapters];
    }
    
    [_tableView reloadData];
}

- (void)changeScending
{
    if (self.chapters.count==0){
        [MBProgressHUD showError:@"暂无章节信息"];
        return;
    }
    
    if (self.isDescending){
        [self.button setImage:kGetImage(@"mulu_descending") forState:UIControlStateNormal];
        self.dataArray = [NSArray arrayWithArray:self.chapters];
    }else{
        [self.button setImage:kGetImage(@"mulu_ascending") forState:UIControlStateNormal];
        NSArray *arr = [[self.chapters reverseObjectEnumerator] allObjects];
        self.dataArray = [NSArray arrayWithArray:arr];
    }
    
    self.isDescending = !self.isDescending;
    
    [_tableView reloadData];
    [self scrollToCurrentIndex];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"titleCell"];
    }
    
    NSInteger row = self.isDescending?(self.dataArray.count-indexPath.row):(indexPath.row + 1);
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@", row, self.dataArray[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    if (row - 1 == self.currentIndex){
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = self.isDescending?(self.dataArray.count-indexPath.row):(indexPath.row + 1);
    if (self.didSelectChapter){
        self.didSelectChapter(row-1);
    }
    self.isShowMulu = NO;
}


@end
