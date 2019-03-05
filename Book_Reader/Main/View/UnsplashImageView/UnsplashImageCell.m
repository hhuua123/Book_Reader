//
//  UnsplashImageCell.m
//  Book_Reader
//
//  Created by hhuua on 2019/3/4.
//  Copyright © 2019 hhuua. All rights reserved.
//

#import "UnsplashImageCell.h"
#import <YYWebImage/YYWebImage.h>
#import "UIColor+random.h"

@interface UnsplashImageCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *loadFailView;
@property (weak, nonatomic) IBOutlet UILabel *loadFailLabel;

@end

@implementation UnsplashImageCell

- (void)setModel:(UnsplashImageModel *)model
{
    _model = model;
 
    [self loadImage];
}

- (void)loadImage
{
    self.loadFailView.hidden = YES;
    
    NSString* url = [_model.urls objectForKey:@"small"];
    
    _imageV.image = nil;
    [_imageV yy_setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (error){
            self.imageV.image = nil;
            self.loadFailView.hidden = NO;
        }
    }];
}

- (BOOL)reloadImage
{
    if (!self.loadFailView.hidden){
        self.loadFailView.hidden = YES;
        
        [self loadImage];
        
        return YES;
    }
    
    return NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backView.layer.cornerRadius = 5;
    self.loadFailView.layer.cornerRadius = 5;
    self.backView.clipsToBounds = YES;
    self.backView.backgroundColor = [UIColor randomLightColor];
}

- (IBAction)reloadTap:(UITapGestureRecognizer *)sender
{
    [self loadImage];
}


@end
