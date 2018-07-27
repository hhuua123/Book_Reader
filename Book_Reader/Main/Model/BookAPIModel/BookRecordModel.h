//
//  BookRecordModel.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/26.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookRecordModel : NSObject

@property (nonatomic,copy) NSString* book_id;
@property (nonatomic,assign) NSInteger chapter_index;
@property (nonatomic,copy) NSString* chapter_name;
@property (nonatomic,copy) NSString* record_text;
@property (nonatomic,strong) NSDate* record_time;

- (instancetype)initWithId:(NSString*)book_id
                     index:(NSInteger)index
                    record:(NSString*)record
               chapterName:(NSString*)chapterName;

@end
