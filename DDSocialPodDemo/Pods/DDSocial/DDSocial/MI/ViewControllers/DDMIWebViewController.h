//
//  DDMIWebViewController.h
//  midong
//
//  Created by lilingang on 16/4/23.
//  Copyright © 2016年 HM IOS Team. All rights reserved.
//

#import "DDMIBaseViewController.h"

@interface DDMIWebViewController : DDMIBaseViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

/**
 *  @brief 默认首次加载完整的URL字符串，子类必须实现
 *
 *  @return NSString
 */
- (NSString *)loadWholeURLString;

/**
 *  @brief webView是否可以加载
 *
 *  @param request NSURLRequest
 *
 *  @return YES ？ 允许 : 不允许
 */
- (BOOL)shouldStartLoadWithRequest:(NSURLRequest *)request;

@end
