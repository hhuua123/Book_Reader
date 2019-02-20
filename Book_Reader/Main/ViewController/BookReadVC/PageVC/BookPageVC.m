//
//  BookPageVC.m
//  Book_Reader
//
//  Created by hhuua on 2019/2/20.
//  Copyright © 2019 hhuua. All rights reserved.
//

#import "BookPageVC.h"

@interface BookPageVC ()

@end

@implementation BookPageVC

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_block){
        _block();
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

@end
