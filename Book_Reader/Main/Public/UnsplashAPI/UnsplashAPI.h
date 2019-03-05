//
//  UnsplashAPI.h
//  Book_Reader
//
//  Created by hhuua on 2019/3/4.
//  Copyright © 2019 hhuua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnsplashImageModel.h"

typedef NS_ENUM(NSInteger, kGetImageListOrder){
    GetImageListOrderLatest = 0,    /* 最新*/
    GetImageListOrderOldest,        /* 最旧*/
    GetImageListOrderPopular,       /* 最受欢迎*/
};

typedef void (^getImageListSuccess)(NSArray<UnsplashImageModel*>* images, NSInteger page);
typedef void (^UnsplashFail)(NSError* error);

@interface UnsplashAPI : NSObject

- (void)getImageListWithPage:(NSInteger)page
                       order:(enum kGetImageListOrder)order
                     success:(getImageListSuccess)success
                        Fail:(UnsplashFail)fail;

- (void)getImageListWithPage:(NSInteger)page
                     success:(getImageListSuccess)success
                        Fail:(UnsplashFail)fail;

- (void)searchImageListWithKeyWord:(NSString*)kw
                              page:(NSInteger)page
                           success:(getImageListSuccess)success
                              Fail:(UnsplashFail)fail;

@end

