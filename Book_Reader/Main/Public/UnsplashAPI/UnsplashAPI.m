//
//  UnsplashAPI.m
//  Book_Reader
//
//  Created by hhuua on 2019/3/4.
//  Copyright © 2019 hhuua. All rights reserved.
//

#import "UnsplashAPI.h"
#import <AFNetworking/AFNetworking.h>
#import "NSError+HYError.h"

@interface UnsplashAPI()

@end

@implementation UnsplashAPI

- (void)searchImageListWithKeyWord:(NSString*)kw
                              page:(NSInteger)page
                           success:(getImageListSuccess)success
                              Fail:(UnsplashFail)fail
{
    AFHTTPSessionManager* manager = [self UnsplashManager];
    
    NSString* url = @"https://api.unsplash.com/search/photos?";
    NSDictionary* dic = @{
                          @"page" : @(page),
                          @"per_page" : @(30),
                          @"query" : kw
                          };
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray* arr = [NSMutableArray array];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSArray* results = [responseObject objectForKey:@"results"];
            
            for (NSDictionary* dic in results) {
                UnsplashImageModel* model = [[UnsplashImageModel alloc] initWithDic:dic];
                if (model){
                    [arr addObject:model];
                }
            }
            
            if (success){
                success(arr, page);
            }
        }else{
            NSError* err = [NSError errorWithDescription:@"responseObject 类型错误,与接口文档不符!"];
            if (fail){
                fail(err);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail){
            fail(error);
        }
    }];
    
}

- (void)getImageListWithPage:(NSInteger)page
                       order:(enum kGetImageListOrder)order
                     success:(getImageListSuccess)success
                        Fail:(UnsplashFail)fail
{
    AFHTTPSessionManager* manager = [self UnsplashManager];

    NSString* url = @"https://api.unsplash.com/photos?";
    NSString* orderType;
    switch (order) {
        case GetImageListOrderLatest:
            orderType = @"latest";
            break;
        case GetImageListOrderOldest:
            orderType = @"oldest";
            break;
        case GetImageListOrderPopular:
            orderType = @"popular";
            break;
            
        default:
            break;
    }
    NSDictionary* dic = @{
                          @"page" : @(page),
                          @"per_page" : @(30),
                          @"order_by" : orderType
                          };
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray* arr = [NSMutableArray array];
        if ([responseObject isKindOfClass:[NSArray class]]){
            for (NSDictionary* dic in responseObject) {
                UnsplashImageModel* model = [[UnsplashImageModel alloc] initWithDic:dic];
                if (model){
                    [arr addObject:model];
                }
            }
            
            if (success){
                success(arr, page);
            }
        }else{
            NSError* err = [NSError errorWithDescription:@"responseObject 类型错误,与接口文档不符!"];
            if (fail){
                fail(err);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail){
            fail(error);
        }
    }];
}

- (void)getImageListWithPage:(NSInteger)page
                     success:(getImageListSuccess)success
                        Fail:(UnsplashFail)fail
{
    [self getImageListWithPage:page order:GetImageListOrderLatest success:success Fail:fail];
}

- (AFHTTPSessionManager*)UnsplashManager
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer new];
    [manager.requestSerializer setValue:@"Client-ID fa60305aa82e74134cabc7093ef54c8e2c370c47e73152f72371c828daedfcd7" forHTTPHeaderField:@"Authorization"];
    
    return manager;
}

@end
