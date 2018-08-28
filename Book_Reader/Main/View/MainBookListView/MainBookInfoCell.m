//
//  MainBookInfoCell.m
//  Book_Reader
//
//  Created by hhuua on 2018/7/3.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "MainBookInfoCell.h"
#import <YYWebImage/YYWebImage.h>

@interface MainBookInfoCell()
@property (weak, nonatomic) IBOutlet UIImageView *bookImageV;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookRecordLabel;

@end
@implementation MainBookInfoCell
- (void)setModel:(BookSaveInfoModel *)model
{
    _model = model;
    
    [_bookImageV yy_setImageWithURL:[NSURL URLWithString:_model.bookInfo.book_image] placeholder:nil options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
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
