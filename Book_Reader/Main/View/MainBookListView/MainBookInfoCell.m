//
//  MainBookInfoCell.m
//  Book_Reader
//
//  Created by hhuua on 2018/7/3.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "MainBookInfoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MainBookInfoCell()
@property (weak, nonatomic) IBOutlet UIImageView *bookImageV;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookRecordLabel;

@end
@implementation MainBookInfoCell

- (void)setModel:(BookSaveInfoModel *)model
{
    _model = model;
    
    [_bookImageV sd_setImageWithURL:[NSURL URLWithString:_model.bookInfo.book_image] placeholderImage:kGetImage(@"placeholder_loding") options:SDWebImageProgressiveDownload | SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error){
            [self.bookImageV setImage:kGetImage(@"placeholder_empty")];
        }
    }];
    
    _bookNameLabel.text = _model.bookInfo.book_name;
    NSString* rc = _model.bookRecord.chapter_name?:@"还未开始阅读";
    _bookRecordLabel.text = [NSString stringWithFormat:@"已阅读到:%@",rc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
