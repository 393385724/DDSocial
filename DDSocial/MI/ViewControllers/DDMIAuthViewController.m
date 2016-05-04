//
//  DDMIAuthViewController.m
//  HMLoginDemo
//
//  Created by lilingang on 15/8/4.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import "DDMIAuthViewController.h"

NSString * const DDMIAuthAPIName = @"https://account.xiaomi.com/oauth2/authorize";
NSString * const DDMISwitchAccountAPIName = @"https://account.xiaomi.com/oauth2/switchAccounts";
NSString * const DDMIUserAuthorization = @"https://account.xiaomi.com/oauth2/userAuthorization";

@interface DDMIAuthViewController ()<UIWebViewDelegate>

@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *redirectUrl;

@end

@implementation DDMIAuthViewController

- (instancetype)initWithAppid:(NSString *)appID redirectUrl:(NSString *)redirectUrl{
    self = [super init];
    if (self) {
        self.appID = appID;
        self.redirectUrl = redirectUrl;
    }
    return self;
}

#pragma mark - Template Methods

- (DDMINavigationLeftBarAction)leftBarAction{
    return DDMINavigationLeftBarActionCancel;
}

- (NSString *)loadWholeURLString{
    NSString *urlString = DDMIAuthAPIName;
    if ([self.appID length] && [self.redirectUrl length]) {
        NSString *response_type = self.authMode == DDSSAuthModeCode ? @"code":@"token";
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *localeString = [languages objectAtIndex:0];
        urlString = [urlString stringByAppendingFormat:@"?client_id=%@&redirect_uri=%@&response_type=%@&_locale=%@",self.appID,self.redirectUrl,response_type,localeString];
    }
    return urlString;
}

- (BOOL)shouldStartLoadWithRequest:(NSURLRequest *)request{
    if ([request.URL.absoluteString hasPrefix:self.redirectUrl]) {
        [self didFinishedAuthWithRequest:request];
    } else if ([request.URL.absoluteString hasPrefix:DDMISwitchAccountAPIName]){
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([request.URL.absoluteString hasPrefix:DDMIUserAuthorization]){
        [self.activityIndicator startAnimating];
    }
    return YES;
}

#pragma mark - Private Methods

- (void)didFinishedAuthWithRequest:(NSURLRequest *)request{
    NSString *responseString = @"";
    if (self.authMode == DDSSAuthModeCode) {
        responseString = request.URL.query;
    } else {
        responseString = request.URL.fragment;
    }
    NSDictionary *responseDict = [self responseFromqueryString:responseString];
    
    NSInteger errorCode = [[responseDict objectForKey:@"error"] integerValue];
    if (!errorCode) {
        //登录成功
        if (self.delegate && [self.delegate respondsToSelector:@selector(authViewController:successWithResponse:)]) {
            [self.delegate authViewController:self successWithResponse:responseDict];
        }
    }
    else{
        NSString *errorDescription = [responseDict objectForKey:@"error_description"];
        NSError *error = [NSError errorWithDomain:@"MiPassportSDKErrorDomain" code:errorCode userInfo:@{@"description":errorDescription}];
        if (self.delegate && [self.delegate respondsToSelector:@selector(authViewController:failedWithError:)]) {
            [self.delegate authViewController:self failedWithError:error];
        }
    }
}

- (NSDictionary *)responseFromqueryString:(NSString *)query{
    NSArray *keyValuePairArray = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
    for (NSString *keyValuePair in keyValuePairArray) {
        NSArray *tmpArray = [keyValuePair componentsSeparatedByString:@"="];
        [response setObject:[tmpArray lastObject] forKey:[tmpArray firstObject]];
    }
    return response;
}

@end
