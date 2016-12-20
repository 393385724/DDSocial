//
//  DDMIAuthViewController.h
//  HMLoginDemo
//
//  Created by lilingang on 15/8/4.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import "DDMIWebViewController.h"
#import "DDSocialTypeDefs.h"

@class DDMIAuthViewController;

@protocol DDMIAuthViewControllerDelegate <NSObject>

- (void)authViewController:(DDMIAuthViewController *)viewController successWithResponse:(NSDictionary *)response;
- (void)authViewController:(DDMIAuthViewController *)viewController failedWithError:(NSError *)error;

@end

@interface DDMIAuthViewController : DDMIWebViewController

@property (nonatomic, weak) id<DDMIAuthViewControllerDelegate> delegate;

@property (nonatomic, assign) DDSSAuthMode authMode;

- (instancetype)initWithAppid:(NSString *)appID redirectUrl:(NSString *)redirectUrl;

@end
