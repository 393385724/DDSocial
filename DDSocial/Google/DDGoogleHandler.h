//
//  DDGoogleHandler.h
//  DDSocialDemo
//
//  Created by lilingang on 16/4/11.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialEventDefs.h"

@class UIApplication;
@class UIViewController;

@interface DDGoogleHandler : NSObject

/**
 *  @brief 注册Google
 *
 *  @return YES ? 成功 : 失败
 */
- (BOOL)registerApp;

/**
 *  @brief  处理Google通过URL启动App时传递的数据
 *
 *  @param application       当前的application
 *  @param url               facebook启动第三方应用时传递过来的URL
 *  @param sourceApplication 唤起该app的app
 *  @param annotation        参数
 *
 *  @return YES ? 唤起成功 : 唤起失败
 */
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

/**
 *  @brief Google授权
 *
 *  @param viewController 当前的ViewController
 *  @param handler        回调方法
 *
 *  @return YES ? 唤起成功 : 唤起失败
 */
- (BOOL)authWithViewController:(UIViewController *)viewController
                       handler:(DDSSAuthEventHandler)handler;

@end
