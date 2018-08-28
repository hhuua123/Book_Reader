//
//  MainBookRightCell.m
//  Book_Reader
//
//  Created by hhuua on 2018/7/3.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "MainBookRightCell.h"

@interface MainBookRightCell()
@property (weak, nonatomic) IBOutlet UIView *imageBackView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end
@implementation MainBookRightCell
- (void)changeBackColor:(UIColor*)color Image:(UIImage*)image Name:(NSString*)name
{
    self.imageBackView.backgroundColor = color;
    self.imageV.image = image;
    self.nameLabel.text = name;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageBackView.layer.cornerRadius = 3;
    self.imageBackView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
