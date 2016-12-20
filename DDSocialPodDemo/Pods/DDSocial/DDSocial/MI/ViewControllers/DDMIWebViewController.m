//
//  DDMIWebViewController.m
//  midong
//
//  Created by lilingang on 16/4/23.
//  Copyright © 2016年 HM IOS Team. All rights reserved.
//

#import "DDMIWebViewController.h"

@interface DDMIWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *loadProgressView;

@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, assign) BOOL didFinishLoad;

@end

@implementation DDMIWebViewController

- (instancetype)init{
    self = [super initWithNibName:@"DDMIWebViewController" bundle:MIResourceBundle];
    if (self) {
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
    NSURL *url = [NSURL URLWithString:[self loadWholeURLString]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [self.webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
    [self.myTimer invalidate];
    self.myTimer = nil;
    [self.activityIndicator stopAnimating];
}

#pragma mark - Template Methods

- (DDMINavigationLeftBarAction)leftBarAction{
    return DDMINavigationLeftBarActionBack;
}

- (NSURLRequest *)loadWholeURLString{
    NSLog(@"子类必须实现loadWholeURLString");
    return nil;
}

- (BOOL)shouldStartLoadWithRequest:(NSURLRequest *)request{
    return YES;
}

#pragma mark - Private Methods

- (void)calculateProgressView{
    if (self.didFinishLoad) {
        if (self.loadProgressView.progress >= 1) {
            self.loadProgressView.hidden = YES;
            [self.myTimer invalidate];
            self.myTimer = nil;
        } else {
            self.loadProgressView.progress += 0.1;
        }
    } else {
        if (self.loadProgressView.progress < 0.95) {
            self.loadProgressView.progress += 0.05;
        }
    }
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
    return [self shouldStartLoadWithRequest:request];
}

@end
