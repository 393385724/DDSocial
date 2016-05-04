//
//  DDMIRequestHandle.h
//  HMLoginDemo
//
//  Created by lilingang on 15/8/3.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMIErrorTool.h"


typedef void (^DDMIRequestBlock) (NSDictionary *responseDict, NSError *connectionError);
typedef void (^DDMIRegisterRequestBlock) (NSDictionary *responseDict, NSError *connectionError, NSString *errorMessage);

@class DDMIRequestHandle;

@protocol DDMIRequestHandleDelegate <NSObject>

- (void)requestHandleDidSuccess:(DDMIRequestHandle *)requestHandle;
- (void)requestHandle:(DDMIRequestHandle *)requestHandle failedWithType:(DDMIErrorType)errorType errorMessage:(NSString *)errorMessage error:(NSError *)error;

@end

@interface DDMIRequestHandle : NSObject

@property (nonatomic, weak) id<DDMIRequestHandleDelegate> delegate;

@property (nonatomic, copy, readonly) NSString *account;

/**
 *  @brief 登录小米账号
 *
 *  @param account    小米账号
 *  @param passWord   密码
 *  @param verifyCode 验证码
 */
- (void)loginWithAccount:(NSString *)account
                password:(NSString *)passWord
              verifyCode:(NSString *)verifyCode;

/**
 *  @brief 验证安全令牌
 *
 *  @param OTPCode 令牌码
 *  @param isTrust 是不是添加信任设备
 */
- (void)checkOTPCode:(NSString *)OTPCode trustDevice:(BOOL)isTrust;

/**
 *  @brief 注册时检查短信的限额
 *
 *  @param phoneNumber     手机号
 *  @param completeHandler 回调
 */
- (void)checkSMSQuotaWithPhoneNumber:(NSString *)phoneNumber
                     completeHandler:(DDMIRegisterRequestBlock)completeHandler;

/**
 *  @brief 注册时验证图片验证码
 *
 *  @param ticket          验证码
 *  @param phoneNumber     手机号
 *  @param completeHandler 回调
 */
- (void)sendPhoneTicket:(NSString *)ticket
            phoneNumber:(NSString *)phoneNumber
        completeHandler:(DDMIRegisterRequestBlock)completeHandler;

/**
 *  @brief 注册小米账号
 *
 *  @param phoneNumber     手机号
 *  @param password        密码
 *  @param code            短信验证码
 *  @param completeHandler 回调
 */
- (void)registerAccountWithPhoneNumber:(NSString *)phoneNumber
                              password:(NSString *)password
                               smsCode:(NSString *)code
                       completeHandler:(DDMIRegisterRequestBlock)completeHandler;

/**
 *  @brief 获取小米个人信息
 *
 *  @param accessToken     授权获取的accessToken
 *  @param clientId        授权获取的clientId
 *  @param completeHandler 回调
 *
 *  @return YES ? 发送成功:发送失败
 */
- (BOOL)getProfileWithAccessToken:(NSString *)accessToken
                         clientId:(NSString *)clientId
                  completeHandler:(DDMIRequestBlock)completeHandler;

@end
