//
//  DDAuthItem.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDAuthItem : NSObject

/**
 *  @brief 第三方获取的code或者token
 */
@property (nonatomic, copy) NSString *thirdToken;

/**
 *  @brief 第三方申请相对于用户的唯一标示
 */
@property (nonatomic, copy) NSString *thirdId;

/**
 *  @brief 原始授权信息
 */
@property (nonatomic, strong) id rawObject;

/**
 *  @brief 原始个人信息(如果有的话，目前只有line有)
 */
@property (nonatomic, strong) id rawProfileObject;

@end
