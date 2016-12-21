//
//  DDMILoginViewController.h
//  HMLoginDemo
//
//  Created by lilingang on 15/8/4.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import "DDMIBaseViewController.h"

@class DDMIRequestHandle;

@interface DDMILoginViewController : DDMIBaseViewController

/**
 *  @brief 是否显示忘记密码按钮, 默认NO
 */
@property (nonatomic, assign) BOOL showForgotPassword;

/**
 *  @brief 是否显示注册按钮, 默认NO
 */
@property (nonatomic, assign) BOOL showRegister;


- (instancetype)initWithRequestHandle:(DDMIRequestHandle *)requestHandle;

@end
