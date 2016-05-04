//
//  DDMIErrorTool.m
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/28.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDMIErrorTool.h"
#import "DDMIDefines.h"

NSString *const DDMIErrorCodeKey = @"DDMIErrorCodeKey";
NSString *const DDMIErrorMessageKey = @"DDMIErrorMessageKey";

@implementation DDMIErrorTool

+ (NSDictionary *)errorDictionaryWithError:(NSError *)error{
    NSInteger errorCode = [error code];
    NSInteger userInfoErrorCode = [[[error userInfo] objectForKey:@"code"] integerValue];
    NSString *errorMessage = [[[error userInfo] objectForKey:@"desc"] stringByAppendingFormat:@"(%ld)",(long)userInfoErrorCode];
    if (![errorMessage length]) {
        errorMessage = [[error localizedDescription] stringByAppendingFormat:@"(%ld)",(long)errorCode];
    }
    if (![errorMessage length]) {
        errorMessage = [MILocal(@"未知错误") stringByAppendingFormat:@"(%@)",[error localizedDescription]];
    }
    DDMIErrorType errorType = DDMIErrorUnkwon;
    if (errorCode == -1009 ||
        errorCode == -1005 ||
        userInfoErrorCode == -1009 ||
        userInfoErrorCode == -1005) {
        errorType = DDMIErrorNetworkNotConnected;
        errorMessage = MILocal(@"网络未连接");
    }
    
    if (errorCode == -1001 ||
        errorCode == -1002 ||
        userInfoErrorCode == -1001 ||
        userInfoErrorCode == -1002 ) {
        errorType = DDMIErrorTimeOut;
        errorMessage = MILocal(@"请求超时");
    }
    
    if (errorCode == -1003 ||
        userInfoErrorCode == -1003 ) {
        errorType = DDMIErrorNotReachServer;
        errorMessage = MILocal(@"无法连接服务器");
    }
    
    if (errorCode == 403 ||
        userInfoErrorCode == 403 ) {
        errorType = DDMIErrorOperationFrequent;
        errorMessage = MILocal(@"您的操作频率过快，请稍后再试.");
    }
    
    if (errorCode == 10017 ||
        userInfoErrorCode == 10017 ) {
        errorType = DDMIErrorRegisterPhoneNumberInvalid;
        errorMessage = MILocal(@"手机号码格式错误.");
    }
    
    if (errorCode == 70016 ||
        errorCode == 20003 ||
        userInfoErrorCode == 70016 ||
        userInfoErrorCode == 20003 ) {
        errorType = DDMIErrorAccountOrPassword;
        errorMessage = MILocal(@"账号或密码错误,请重新填写.");
    }
    
    if (errorCode == 81003 ||
        userInfoErrorCode == 81003 ) {
        //需要二次验证 或 动态口令错误
        errorType = DDMIErrorNeedDynamicToken;
        errorMessage = MILocal(@"动态口令错误");
    }
    
    if (errorCode == 87001 ||
        userInfoErrorCode == 87001 ) {
        errorType = DDMIErrorVerificationCode;
        errorMessage = MILocal(@"您输入的验证码有误");
    }
    
    if (errorCode == 25001 ||
        userInfoErrorCode == 25001 ) {
        errorType = DDMIErrorRegisterPhoneHasRegistered;
        errorMessage = MILocal(@"该号码已经注册过小米账号");
    }
    
    if (errorCode == 70014 ||
        userInfoErrorCode == 70014 ) {
        errorType = DDMIErrorRegisterCodeInvalid;
        errorMessage = MILocal(@"验证码错误");
    }
    
    if (errorCode == DDMIErrorRegisterSMSQuotaOverflow) {
        errorType = DDMIErrorRegisterSMSQuotaOverflow;
        errorMessage = MILocal(@"您今天已经发送太多短信,请换个时间或改用其他号码");
    }
    
    if (errorCode == DDMIErrorParameter) {
        errorType = DDMIErrorParameter;
        errorMessage = MILocal(@"请求出错了");
    }
    return @{DDMIErrorCodeKey:@(errorCode),DDMIErrorMessageKey:errorMessage};
}

+ (NSString *)errorMessageWithError:(NSError *)error{
    NSDictionary *errorDict = [self errorDictionaryWithError:error];
    return errorDict[DDMIErrorMessageKey];
}

@end
