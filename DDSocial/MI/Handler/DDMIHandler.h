//
//  DDMIHandler.h
//  HMLoginDemo
//
//  Created by lilingang on 15/8/3.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//
/// info.plist 配置 CFBundleURLName为xiaomi

#import <Foundation/Foundation.h>
#import "DDSocialHandlerProtocol.h"

@interface DDMIHandler : NSObject

/**
 *  @brief 配置登录按钮显示
 *
 *  @param showRegister       是否显示注册按钮,默认YES
 *  @param showForgotPassword 是否显示忘记密码按钮,默认YES
 */
+ (void)configShouldShowRegister:(BOOL)showRegister
              showForgotPassword:(BOOL)showForgotPassword;

@end

@interface DDMIHandler (DDSocialHandlerProtocol)<DDSocialHandlerProtocol>

@end
