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

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *loadProgressView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, assign) BOOL didFinishLoad;

@end

@implementation DDMIAuthViewController

- (instancetype)initWithAppid:(NSString *)appID redirectUrl:(NSString *)redirectUrl{
    self = [super initWithNibName:@"DDMIAuthViewController" bundle:MIResourceBundle];
    if (self) {
        self.appID = appID;
        self.redirectUrl = redirectUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.loadProgressView.tintColor = [UIColor orangeColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self load];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
    [self.myTimer invalidate];
    self.myTimer = nil;
    [self.activityIndicator stopAnimating];
}

#pragma mark - Private Methods

- (void)load{
    NSString *urlString = DDMIAuthAPIName;
    if ([self.appID length] && [self.redirectUrl length]) {
        NSString *response_type = self.authMode == DDSSAuthModeCode ? @"code":@"token";
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *localeString = [languages objectAtIndex:0];
        urlString = [urlString stringByAppendingFormat:@"?client_id=%@&redirect_uri=%@&response_type=%@&_locale=%@",self.appID,self.redirectUrl,response_type,localeString];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
}

- (void)calculateProgressView{
    if (self.didFinishLoad) {
        if (self.loadProgressView.progress >= 1) {
            self.loadProgressView.hidden = YES;
            [self.myTimer invalidate];
            self.myTimer = nil;
        }
        else {
            self.loadProgressView.progress += 0.1;
        }
    }
    else{
        if (self.loadProgressView.progress < 0.95) {
            self.loadProgressView.progress += 0.05;
        }
    }
}

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

- (void)switchAccountsAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(authViewControllerSwitchLogin)]) {
        [self.delegate authViewControllerSwitchLogin];
    }
}

//确认登录
- (void)userAuthorization{
    [self.activityIndicator startAnimating];
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

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(calculateProgressView) userInfo:nil repeats:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
    self.didFinishLoad = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.didFinishLoad = YES;
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL.absoluteString hasPrefix:self.redirectUrl]) {
        [self didFinishedAuthWithRequest:request];
    }
    else if ([request.URL.absoluteString hasPrefix:DDMISwitchAccountAPIName]){
        [self switchAccountsAction];
    } else if ([request.URL.absoluteString hasPrefix:DDMIUserAuthorization]){
        [self userAuthorization];
    }
    return YES;
}

@end
