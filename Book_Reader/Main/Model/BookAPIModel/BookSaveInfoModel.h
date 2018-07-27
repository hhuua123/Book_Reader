//
//  BookSaveInfoModel.h
//  Book_Reader
//
//  Created by hhuua on 2018/7/3.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import "BookAPIBaseModel.h"
#import "BookInfoModel.h"
#import "BookRecordModel.h"

@interface BookSaveInfoModel : BookAPIBaseModel

@property (nonatomic,strong) BookInfoModel* bookInfo;
@property (nonatomic,strong) BookRecordModel* bookRecord;

@end
