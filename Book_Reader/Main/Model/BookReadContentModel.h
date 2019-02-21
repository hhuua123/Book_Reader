//
//  BookReadContentModel.h
//  Book_Reader
//
//  Created by hhuua on 2019/2/21.
//  Copyright © 2019 hhuua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookReadContentModel : NSObject

/* 该"页"需要显示的文本内容*/
@property (nonatomic,copy) NSString* text;
/* 章节名称*/
@property (nonatomic,copy) NSString* chapterName;
/* 总页数*/
@property (nonatomic,assign) NSInteger totalNum;
/* 当前页数*/
@property (nonatomic,assign) NSInteger index;

- (instancetype)initWithText:(NSString*)text
                 chapterName:(NSString*)chapterName
                    totalNum:(NSInteger)totalNum
                       index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
