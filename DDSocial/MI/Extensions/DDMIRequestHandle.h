//
//  DDMIRequestHandle.h
//  HMLoginDemo
//
//  Created by lilingang on 15/8/3.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DDMIErrorType) {
    DDMIErrorUnkwon,                //**未知错误*/
    DDMIErrorNetworkNotConnected,   //**网络未连接*/
    DDMIErrorTimeOut,               //**网络超时*/
    DDMIErrorNotReachServer,        //**无法连接服务器*/
    DDMIErrorOperationFrequent,     //**操作频繁*/
    DDMIErrorNeedDynamicToken,      //**需要动态令牌*/
    DDMIErrorAccountOrPassword,     //**账号或密码错误*/
    DDMIErrorVerificationCode,      //**验证码错误*/
};

typedef void (^DDMIRequestBlock) (NSDictionary *responseDict, NSError *connectionError);

@class DDMIRequestHandle;

@protocol DDMIRequestHandleDelegate <NSObject>

- (void)requestHandle:(DDMIRequestHandle *)requestHandle successedNeedDynamicToken:(BOOL)needDynamicToken;
- (void)requestHandle:(DDMIRequestHandle *)requestHandle failedWithType:(DDMIErrorType)errorType errorMessage:(NSString *)errorMessage error:(NSError *)error;

@end

@interface DDMIRequestHandle : NSObject

@property (nonatomic, weak) id<DDMIRequestHandleDelegate> delegate;

@property (nonatomic, copy, readonly) NSString *account;

- (void)loginWithAccount:(NSString *)account
                password:(NSString *)passWord
              verifyCode:(NSString *)verifyCode;

- (void)checkOTPCode:(NSString *)OTPCode trustDevice:(BOOL)isTrust;

- (BOOL)getProfileWithAccessToken:(NSString *)accessToken
                         clientId:(NSString *)clientId
                  completeHandler:(DDMIRequestBlock)completeHandler;

@end
