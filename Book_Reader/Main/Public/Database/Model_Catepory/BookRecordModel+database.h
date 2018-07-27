//
//  BookRecordModel+database.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookRecordModel.h"
#import <FMDB/FMDB.h>

@interface BookRecordModel (database)

- (instancetype)initWithFMResult:(FMResultSet*)result;

@end
