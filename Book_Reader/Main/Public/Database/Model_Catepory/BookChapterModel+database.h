//
//  BookChapterModel+database.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookChapterModel.h"
#import <FMDB/FMDB.h>

@interface BookChapterModel (database)

- (instancetype)initWithFMResult:(FMResultSet*)result;

@end
