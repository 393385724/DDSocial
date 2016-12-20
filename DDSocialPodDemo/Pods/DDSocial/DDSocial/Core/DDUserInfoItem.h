//
//  DDUserInfoItem.h
//  DDSocialCodeDemo
//
//  Created by lilingang on 16/4/19.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialTypeDefs.h"

typedef NS_ENUM(NSUInteger, DDSSGenderType) {
    DDSSGenderTypeUnkown,
    DDSSGenderTypeMale = 1,       //**男性*/
    DDSSGenderTypeFemale = 2,     //**女性*/
};

@interface DDUserInfoItem : NSObject

@property (nonatomic, assign, readonly) DDSSPlatform platform;
//**用户昵称*/
@property (nonatomic, copy, readonly) NSString *nickName;
//**用户个人描述*/
@property (nonatomic, copy, readonly) NSString *desString;
//**性别*/
@property (nonatomic, assign, readonly) DDSSGenderType genderType;
//**用户头像地址*/
@property (nonatomic, copy, readonly) NSString *avatarURL;
/**三方返回的原始数据*/
@property (nonatomic, assign, readonly) id rawObject;

- (instancetype)initWithPlatForm:(DDSSPlatform)platForm rawObject:(id)rawObject;

@end
