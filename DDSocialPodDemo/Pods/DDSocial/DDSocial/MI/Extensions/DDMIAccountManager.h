//
//  DDMIAccountManager.h
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/29.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMIAccountManager : NSObject

/**
 *  @brief 缓存小米账号
 *
 *  @param account 账号id
 */
+ (void)saveUserAccount:(NSString *)account;

/**
 *  @brief 读取缓存账号
 *
 *  @return NSString
 */
+ (NSString *)userAccount;

@end
