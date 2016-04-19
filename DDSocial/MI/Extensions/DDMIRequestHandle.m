//
//  DDMIRequestHandle.m
//  HMLoginDemo
//
//  Created by lilingang on 15/8/3.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import "DDMIRequestHandle.h"
#import <XMPassport/XMPassport.h>
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

#import "DDMIDefines.h"

NSString * const DDMIGetProfileAPI = @"https://open.account.xiaomi.com/user/profile";

@interface DDMIRequestHandle ()<MPSessionDelegate,XMPassportRequestDelegate>

//小米授权过程中保证xmPassport唯一
@property (nonatomic, strong) XMPassport *xmPassport;

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) DDMIRequestBlock getProfileBlock;

@end

@implementation DDMIRequestHandle

- (void)loginWithAccount:(NSString *)account
                password:(NSString *)passWord
              verifyCode:(NSString *)verifyCode{
    self.account = account;
    self.xmPassport = [[XMPassport alloc] initWithUserId:account sid:@"oauth2.0" andDelegate:self];
    if ([verifyCode length]) {
        [self.xmPassport loginWithPassword:passWord encryptedOrNot:NO andVerifyCode:verifyCode];
    }
    else {
        [self.xmPassport loginWithPassword:passWord encryptedOrNot:NO];
    }
}

- (void)checkOTPCode:(NSString *)OTPCode trustDevice:(BOOL)isTrust{
    [self.xmPassport checkOTPCode:OTPCode trustOrNot:isTrust];
}

- (BOOL)getProfileWithAccessToken:(NSString *)accessToken
                         clientId:(NSString *)clientId
                  completeHandler:(DDMIRequestBlock)completeHandler{
    if (!completeHandler) {
        return NO;
    }
    if (!accessToken || !clientId) {
        NSError *error = [NSError errorWithDomain:@"参数错误" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"accessToken、clientId 必填参数不能为空"}];
        completeHandler(nil, error);
        return NO;
    }
    self.getProfileBlock = completeHandler;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:clientId forKey:@"clientId"];
    [params setObject:accessToken forKey:@"token"];
    [self.xmPassport requestWithURL:DDMIGetProfileAPI params:params httpMethod:@"GET" delegate:self needSignature:YES coder:nil];
    return YES;
}

#pragma mark - MPSessionDelegate

- (void)passportDidLogin:(XMPassport *)passport{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestHandle:successedNeedDynamicToken:)]) {
        [self.delegate requestHandle:self successedNeedDynamicToken:NO];
    }
}


- (void)passport:(XMPassport *)passport failedWithError:(NSError *)error{
    NSLog(@"XMPassport Error:%@ code:%ld userInfo:%@",[error localizedDescription],(long)[error code],error.userInfo);
    
    NSInteger errorCode = [error code];
    NSInteger userInfoErrorCode = [[[error userInfo] objectForKey:@"code"] integerValue];
    NSString *errorMessage = [[[error userInfo] objectForKey:@"desc"] stringByAppendingFormat:@"(%ld)",(long)userInfoErrorCode];
    if (![errorMessage length]) {
        errorMessage = [[error localizedDescription] stringByAppendingFormat:@"(%ld)",(long)errorCode];
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
        //请求超时
        errorType = DDMIErrorTimeOut;
        errorMessage = MILocal(@"请求超时");
    }
    
    if (errorCode == -1003 ||
        userInfoErrorCode == -1003 ) {
        //无法连接服务器
        errorType = DDMIErrorNotReachServer;
        errorMessage = MILocal(@"无法连接服务器");
    }
    
    if (errorCode == 403 ||
        userInfoErrorCode == 403 ) {
        //您的操作频率过快，请稍后再试.
        errorType = DDMIErrorOperationFrequent;
        errorMessage = MILocal(@"您的操作频率过快，请稍后再试.");
    }
    
    if (errorCode == 70016 ||
        errorCode == 20003 ||
        userInfoErrorCode == 70016 ||
        userInfoErrorCode == 20003 ) {
        //账号或密码错误
        errorType = DDMIErrorAccountOrPassword;
        errorMessage = MILocal(@"账号或密码错误,请重新填写.");
    }

    if (errorCode == 81003 ||
        userInfoErrorCode == 81003 ) {
        //需要二次验证 或 动态口令错误
        errorType = DDMIErrorNeedDynamicToken;
    }

    if (errorCode == 87001 ||
        userInfoErrorCode == 87001 ) {
        //您输入的验证码有误
        errorType = DDMIErrorVerificationCode;
        errorMessage = MILocal(@"您输入的验证码有误");
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (errorType == DDMIErrorNeedDynamicToken) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestHandle:successedNeedDynamicToken:)]) {
                [self.delegate requestHandle:self successedNeedDynamicToken:YES];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestHandle:failedWithType:errorMessage:error:)]) {
                [self.delegate requestHandle:self failedWithType:errorType errorMessage:errorMessage error:error];
            }
        }
    });
}

#pragma mark - XMPassportRequestDelegate

- (void)request:(XMPassportRequest *)request didFailWithError:(NSError *)error{
    if ([request.url isEqualToString:DDMIGetProfileAPI]) {
        self.getProfileBlock(nil, error);
        self.getProfileBlock = nil;
    }
}

- (void)request:(XMPassportRequest *)request didLoadRawResponse:(NSData *)data{
    NSError *jsonError;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
    if (jsonError) {
        [self request:request didFailWithError:jsonError];
    } else {
        NSInteger code = [[responseDict objectForKey:@"code"] integerValue];
        if (code == 0) {
            NSDictionary *dataDict = [responseDict objectForKey:@"data"];
            if ([request.url isEqualToString:DDMIGetProfileAPI]) {
                self.getProfileBlock(dataDict, nil);
                self.getProfileBlock = nil;
            }
        } else {
            NSError *error = [NSError errorWithDomain:@"服务器错误" code:code userInfo:responseDict];
            [self request:request didFailWithError:error];
        }
    }
}
@end
