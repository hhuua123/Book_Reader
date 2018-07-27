//
//  BookInfoModel.m
//  Book_Reader
//
//  Created by hhuua on 2018/6/25.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookInfoModel.h"

@implementation BookInfoModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"书名:%@,作者:%@,id:%@,更新时间:%@,当前源:%@,简介:%@",self.book_name,self.author,self.related_id,self.update_time,self.book_url,self.book_desc];
}

@end
