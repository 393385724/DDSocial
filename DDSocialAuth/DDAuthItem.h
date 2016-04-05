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
 *  @brief 第三方申请相对与用户的唯一标示
 */
@property (nonatomic, copy) NSString *thirdId;

/**
 *  @brief 小米授权返回的mac_key
 */
@property (nonatomic, copy) NSString *thirdTokenId;

@end
