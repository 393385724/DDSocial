//
//  MPWebViewController.h
//  MiPassportFoundation
//
//  Created by 李 业 on 13-11-28.
//  Copyright (c) 2013年 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPWebViewControllerDelegate;

@interface MPWebViewController : UIViewController
{
    UIWebView *webView;
    UIButton *closeButton;
    UIActivityIndicatorView *indicatorView;
}

@property (nonatomic, weak) id<MPWebViewControllerDelegate> delegate;

- (id)initWithURL:(NSString*) loginURL
       authParams:(NSDictionary *)params
          cookies:(NSArray *)cookies
      redirectURI:(NSString *)redirectURI
         delegate:(id<MPWebViewControllerDelegate>)delegate;

- (void)show;
- (void)hide;
@end

@protocol MPWebViewControllerDelegate <NSObject>

- (void)webViewController:(MPWebViewController *)webViewController didRecieveAuthorizationInfo:(NSDictionary *)authorizeInfo;
- (void)webViewController:(MPWebViewController *)webViewController didFailWithError:(NSError *)error;
- (void)webViewControllerDidCancel:(MPWebViewController *)webViewController;

@end
