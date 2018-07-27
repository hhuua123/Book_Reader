//
//  BookSaveInfoModel+database.h
//  Book_Reader
//
//  Created by hhuua on 2018/7/3.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import <FMDB/FMDB.h>
#import "BookSaveInfoModel.h"
#import "BookInfoModel+database.h"
#import "BookRecordModel+database.h"

@interface BookSaveInfoModel (database)

- (instancetype)initWithFMResult:(FMResultSet*)result;

@end
