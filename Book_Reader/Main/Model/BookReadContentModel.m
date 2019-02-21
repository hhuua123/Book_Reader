//
//  BookReadContentModel.m
//  Book_Reader
//
//  Created by hhuua on 2019/2/21.
//  Copyright © 2019 hhuua. All rights reserved.
//

#import "BookReadContentModel.h"

@implementation BookReadContentModel

- (instancetype)initWithText:(NSString*)text
                 chapterName:(NSString*)chapterName
                    totalNum:(NSInteger)totalNum
                       index:(NSInteger)index
{
    self = [super init];
    if(self){
        self.text           = text;
        self.chapterName    = chapterName;
        self.totalNum       = totalNum;
        self.index          = index;
    }
    return self;
}

@end
