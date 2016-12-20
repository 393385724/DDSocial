//
//  DDMIErrorTool.h
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/28.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const DDMIErrorCodeKey;
extern NSString * const DDMIErrorMessageKey;

typedef NS_ENUM(NSUInteger, DDMIErrorType) {
    DDMIErrorNone,                           //**没有错误*/
    DDMIErrorNetworkNotConnected,            //**网络未连接*/
    DDMIErrorTimeOut,                        //**网络超时*/
    DDMIErrorNotReachServer,                 //**无法连接服务器*/
    DDMIErrorOperationFrequent,              //**操作频繁*/
    DDMIErrorNeedDynamicToken,               //**需要动态令牌*/
    DDMIErrorAccountOrPassword,              //**账号或密码错误*/
    DDMIErrorVerificationCode,               //**验证码错误*/
    DDMIErrorRegisterSMSQuotaOverflow,       //**手机验证码超限*/
    DDMIErrorRegisterPhoneHasRegistered,     //**手机号已经注册错误*/
    DDMIErrorRegisterPhoneNumberInvalid,     //**手机号错误*/
    DDMIErrorRegisterCodeInvalid,            //**验证码错误*/
    DDMIErrorParameter,                      //**上行参数错误*/
    DDMIErrorUnkwon,                         //**未知错误*/
};


@interface DDMIErrorTool : NSObject

/**
 *  @brief 根据NSError解析出要展示的信息
 *
 *  @param error NSError
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)errorDictionaryWithError:(NSError *)error;


/**
 *  @brief 根据NSError解析出要展示的Error
 *
 *  @param error NSError对象
 *
 *  @return error信息String
 */
+ (NSString *)errorMessageWithError:(NSError *)error;

@end
