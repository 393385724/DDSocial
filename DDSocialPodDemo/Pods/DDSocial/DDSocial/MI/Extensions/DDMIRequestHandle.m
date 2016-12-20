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
#import "DDMIErrorTool.h"

NSString * const DDMISMSQuotaAPI = @"https://account.xiaomi.com/pass/sms/quota";
NSString * const DDMIRegisterSendPhoneTicketAPI = @"https://account.xiaomi.com/pass/sendPhoneTicket";
NSString * const DDMIRegisterNewAccountAPI = @"https://api.account.xiaomi.com/pass/user/full/@phone";
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

- (void)checkSMSQuotaWithPhoneNumber:(NSString *)phoneNumber
                     completeHandler:(DDMIRegisterRequestBlock)completeHandler{
    if (!completeHandler) {
        return;
    }
    if (MIIsEmptyString(phoneNumber)) {
        NSError *error = [NSError errorWithDomain:@"parameter Error" code:DDMIErrorParameter userInfo:@{NSLocalizedDescriptionKey:@"phoneNumber require can not nil"}];
        NSString *errorMessage = [DDMIErrorTool errorMessageWithError:error];
        completeHandler(nil,error,errorMessage);
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"-1L" forKey:@"userId"];
    [params setObject:@"4000002" forKey:@"contentType"];
    [params setObject:phoneNumber forKey:@"address"];
    [self loadWithURL:DDMISMSQuotaAPI method:@"POST" params:params completeHandler:completeHandler];
}

- (void)sendPhoneTicket:(NSString *)ticket
            phoneNumber:(NSString *)phoneNumber
             completeHandler:(DDMIRegisterRequestBlock)completeHandler{
    if (!completeHandler) {
        return;
    }
    if (MIIsEmptyString(phoneNumber)) {
        NSError *error = [NSError errorWithDomain:@"parameter Error" code:DDMIErrorParameter userInfo:@{NSLocalizedDescriptionKey:@"phoneNumber require can not nil"}];
        NSString *errorMessage = [DDMIErrorTool errorMessageWithError:error];
        completeHandler(nil,error,errorMessage);
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:phoneNumber forKey:@"phone"];
    [params setObject:ticket forKey:@"icode"];
    [self loadWithURL:DDMIRegisterSendPhoneTicketAPI method:@"POST" params:params completeHandler:completeHandler];
}

- (void)registerAccountWithPhoneNumber:(NSString *)phoneNumber
                              password:(NSString *)password
                               smsCode:(NSString *)code
                       completeHandler:(DDMIRegisterRequestBlock)completeHandler{
    if (!completeHandler) {
        return;
    }
    if (MIIsEmptyString(phoneNumber) ||
        MIIsEmptyString(password) ||
        MIIsEmptyString(code)) {
        NSError *error = [NSError errorWithDomain:@"parameter Error" code:DDMIErrorParameter userInfo:@{NSLocalizedDescriptionKey:@"phoneNumber、password、code require can not nil"}];
        NSString *errorMessage = [DDMIErrorTool errorMessageWithError:error];
        completeHandler(nil,error,errorMessage);
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:phoneNumber forKey:@"phone"];
    [params setObject:password forKey:@"password"];
    [params setObject:code forKey:@"ticket"];
    [self loadWithURL:DDMIRegisterNewAccountAPI method:@"POST" params:params completeHandler:completeHandler];
}

- (BOOL)getProfileWithAccessToken:(NSString *)accessToken
                         clientId:(NSString *)clientId
                  completeHandler:(DDMIRequestBlock)completeHandler{
    if (!completeHandler) {
        return NO;
    }
    if (MIIsEmptyString(accessToken) ||
        MIIsEmptyString(clientId)) {
        NSError *error = [NSError errorWithDomain:@"参数错误" code:DDMIErrorParameter userInfo:@{NSLocalizedDescriptionKey:@"accessToken、clientId 必填参数不能为空"}];
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

#pragma mark - Private Methods

#pragma mark - NetWork

- (NSURLSessionDataTask *)loadWithURL:(NSString *)url method:(NSString *)methodName params:(NSDictionary *)params completeHandler:(DDMIRegisterRequestBlock)completeHandler{
    NSMutableURLRequest *urlRequest = [self requestWithMethod:methodName urlString:url parameters:params];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSString *errorMessage = [DDMIErrorTool errorMessageWithError:error];
                completeHandler(nil,error,errorMessage);
            } else {
                NSString *reqString = [[NSString  alloc] initWithData:data encoding:NSUTF8StringEncoding];
                reqString = [reqString stringByReplacingOccurrencesOfString:@"&&&START&&&" withString:@""];
                if ([reqString length] <= 0) {
                    NSError *tmpError = [NSError errorWithDomain:@"Unkown Error" code:DDMIErrorUnkwon userInfo:@{NSLocalizedDescriptionKey:@"service returns structure errors"}];
                    NSString *errorMessage = [DDMIErrorTool errorMessageWithError:tmpError];
                    completeHandler(nil,tmpError,errorMessage);
                } else {
                    NSData *jsonData = [reqString dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *jsonError;
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
                    if (jsonError) {
                        NSString *errorMessage = [DDMIErrorTool errorMessageWithError:jsonError];
                        completeHandler(nil,error,errorMessage);
                    } else {
                        NSInteger errorCode = [jsonDict[@"code"] integerValue];
                        if (errorCode != 0) {
                            NSError *tmpError = [NSError errorWithDomain:jsonDict[@"reason"] code:errorCode userInfo:jsonDict];
                            NSString *errorMessage = [DDMIErrorTool errorMessageWithError:tmpError];
                            completeHandler(nil,tmpError,errorMessage);
                        } else {
                            completeHandler(jsonDict,nil,nil);
                        }
                    }
                }
            }
        });
    }];
    [dataTask resume];
    return dataTask;
}

- (NSString *)percentEscapedStringFromString:(NSString *)string{
    NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    return escaped;
}

//参见AFNetWorking
- (NSMutableURLRequest *)requestWithMethod:(NSString *)methodName
                                 urlString:(NSString *)urlString
                                parameters:(NSDictionary *)parameters{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    mutableRequest.HTTPMethod = methodName;
    
    NSString *query = nil;
    if (parameters) {
        NSMutableArray *mutablePairs = [NSMutableArray array];
        for (NSString *key in [parameters allKeys]) {
            id value = parameters[key];
            NSString *fieldString = [self percentEscapedStringFromString:[key description]];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutablePairs addObject:fieldString];
            } else {
                NSString *valueString = [self percentEscapedStringFromString:[value description]];
                [mutablePairs addObject:[NSString stringWithFormat:@"%@=%@", fieldString,valueString]];
            }
        }
        query = [mutablePairs componentsJoinedByString:@"&"];
    }
    
    if ([methodName isEqualToString:@"GET"] ||
        [methodName isEqualToString:@"DELETE"]) {
        if (query && [query length] > 0) {
            mutableRequest.URL = [NSURL URLWithString:[[mutableRequest.URL absoluteString] stringByAppendingFormat:mutableRequest.URL.query ? @"&%@" : @"?%@", query]];
        }
    } else {
        if (!query) {
            query = @"";
        }
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        }
        [mutableRequest setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return mutableRequest;
}

#pragma mark - MPSessionDelegate

- (void)passportDidLogin:(XMPassport *)passport{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestHandleDidSuccess:)]) {
        [self.delegate requestHandleDidSuccess:self];
    }
}

- (void)passport:(XMPassport *)passport failedWithError:(NSError *)error{
    NSDictionary *errorDict = [DDMIErrorTool errorDictionaryWithError:error];
    DDMIErrorType errorType = [errorDict[DDMIErrorCodeKey] integerValue];
    NSString *errorMessage = errorDict[DDMIErrorMessageKey];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestHandle:failedWithType:errorMessage:error:)]) {
            [self.delegate requestHandle:self failedWithType:errorType errorMessage:errorMessage error:error];
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
