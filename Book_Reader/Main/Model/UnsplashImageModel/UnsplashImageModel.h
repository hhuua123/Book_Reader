//
//  UnsplashImageModel.h
//  Book_Reader
//
//  Created by hhuua on 2019/3/4.
//  Copyright © 2019 hhuua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class UnsplashUserModel;
@interface UnsplashImageModel : NSObject
- (UnsplashImageModel*)initWithDic:(NSDictionary *)dic;

/* id*/
@property (nonatomic, copy) NSString* imageId;
/* 创建时间*/
@property (nonatomic, copy) NSString* created_at;
/* 上传时间*/
@property (nonatomic, copy) NSString* updated_at;
/* 宽*/
@property (nonatomic, assign) NSInteger width;
/* 高*/
@property (nonatomic, assign) NSInteger height;
/* 主色*/
@property (nonatomic, copy) NSString* color;
/* 描述*/
@property (nonatomic, copy) NSString* imgDescription;
/* 喜欢数*/
@property (nonatomic, assign) NSInteger likes;
/* 作者信息*/
@property (nonatomic, copy) UnsplashUserModel* user;
/* 图片列表(raw,full,regular,small,thumb)*/
@property (nonatomic, copy) NSDictionary* urls;

@end

@interface UnsplashUserModel : NSObject
/* 作者id*/
@property (nonatomic, copy) NSString* userId;
/* 最后上传时间*/
@property (nonatomic, copy) NSString* updated_at;
/* 用户名称*/
@property (nonatomic, copy) NSString* username;
/* 名称*/
@property (nonatomic, copy) NSString* name;
/* fristname*/
@property (nonatomic, copy) NSString* first_name;
/* lastname*/
@property (nonatomic, copy) NSString* last_name;
/* Twitter名称*/
@property (nonatomic, copy) NSString* twitter_username;
/* 页面*/
@property (nonatomic, copy) NSString* portfolio_url;
/* 个人简历*/
@property (nonatomic, copy) NSString* bio;
/* 位置*/
@property (nonatomic, copy) NSString* location;
/* 用户头像(small,medium,large)*/
@property (nonatomic, copy) NSDictionary* profile_image;
/* instagram用户名*/
@property (nonatomic, copy) NSString* instagram_username;
/* 总收藏数*/
@property (nonatomic, assign) NSInteger total_collections;
/* 总喜欢数*/
@property (nonatomic, assign) NSInteger total_likes;
/* 总照片数*/
@property (nonatomic, assign) NSInteger total_photos;

@end

NS_ASSUME_NONNULL_END
