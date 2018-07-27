//
//  BookChapterModel.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/25.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookChapterModel.h"

@implementation BookChapterModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"source_url:%@,chapter_url:%@,name:%@,chapter_id:%@",self.source_url,self.chapter_url,self.name,self.chapter_id];
}

@end
