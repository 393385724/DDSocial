//
//  DDMIVerifyLoginViewController.h
//  HMLoginDemo
//
//  Created by lilingang on 15/8/5.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import "DDMIBaseViewController.h"

@class DDMIVerifyLoginViewController;
@class DDMIRequestHandle;

@protocol DDMIVerifyLoginViewControllerDelegate <NSObject>

- (void)viewControllerDidVerifySucess:(DDMIVerifyLoginViewController *)viewController;
- (void)viewControllerNeedPop:(DDMIVerifyLoginViewController *)viewController;

@end

@interface DDMIVerifyLoginViewController : DDMIBaseViewController

@property (nonatomic, weak) id<DDMIVerifyLoginViewControllerDelegate> delegate;

- (instancetype)initWithRequestHandle:(DDMIRequestHandle *)requestHandle;

@end
