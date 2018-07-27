//
//  BookChapterTextModel+database.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookChapterTextModel.h"
#import <FMDB/FMDB.h>

@interface BookChapterTextModel (database)

- (instancetype)initWithFMResult:(FMResultSet*)result;

#pragma mark - db
@property (nonatomic,strong) NSDate* time;
@property (nonatomic,assign) NSInteger dbId;

@end
