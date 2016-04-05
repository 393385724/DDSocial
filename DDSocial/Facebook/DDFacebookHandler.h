//
//  DDFacebookHandler.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialEventDefs.h"

@protocol DDSocialShareContentProtocol;
@class UIViewController;
@class UIApplication;

@interface DDFacebookHandler : NSObject

/**
 *  @brief  判断Facebook客户端是否安装
 *
 *  @return YES ? 已经安装 : 未安装
 */
+ (BOOL)isFacebookInstalled;

/**
 *  @brief  判断messenger客户端是否安装
 *
 *  @return YES ? 已经安装 : 未安装
 */
+ (BOOL)isMessengerInstalled;

/**
 *  @brief  注册Facebook SDK
 */
- (void)registerApp;

/**
 *  @brief  处理Facebook通过URL启动App时传递的数据
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
 *  @brief  微信授权
 *
 *  @param mode           授权的形式
 *  @param viewController 当前ViewController
 *  @param handler        回调方法
 *
 *  @return YES ? 唤起成功 : 唤起失败
 */
- (BOOL)authWithMode:(DDSSAuthMode)mode
          controller:(UIViewController *)viewController
             handler:(DDSSAuthEventHandler)handler;

/**
 *  @brief  分享内容
 *
 *  @param viewController 当前的ViewController
 *  @param protocol       数据组装协议
 *  @param shareScene     分享场景
 *  @param contentType    内容类型
 *  @param handler        回调
 *
 *  @return YES ? 唤起成功 ： 唤起失败
 */
- (BOOL)shareWithViewController:(UIViewController *)viewController
                       protocol:(id<DDSocialShareContentProtocol>)protocol
                     shareScene:(DDSSScene)shareScene
                    contentType:(DDSSContentType)contentType
                        handler:(DDSSShareEventHandler)handler;

@end
