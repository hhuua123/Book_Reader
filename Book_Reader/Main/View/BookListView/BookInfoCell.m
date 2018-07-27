//
//  BookInfoCell.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/29.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookInfoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BookInfoCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@end
@implementation BookInfoCell
- (void)setModel:(BookInfoModel *)model
{
    _model = model;
    
    if (!kStringIsEmpty(model.book_image))
        [_imageV sd_setImageWithURL:[NSURL URLWithString:_model.book_image] placeholderImage:kGetImage(@"placeholder_loding") options:SDWebImageProgressiveDownload | SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error){
                HYDebugLog(@"%@",imageURL.absoluteString);
                [self.imageV setImage:kGetImage(@"placeholder_empty")];
            }
        }];
        
    _bookNameLabel.text = model.book_name;
    _authorLabel.text = model.author;
    _descriptionLabel.text = model.book_desc;
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)drawRect:(CGRect)rect
{
    
}



@end
