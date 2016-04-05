//
//  DDSinaHandler.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialEventDefs.h"

@protocol DDSocialShareContentProtocol;
@class UIViewController;

@interface DDSinaHandler : NSObject

/**
 *  @brief  判断新浪客户端是否安装
 *
 *  @return YES ? 已经安装 : 未安装
 */
+ (BOOL)isSinaInstalled;

/**
 *  @brief 向新浪终端程序注册第三方应用
 *
 *  @param appid 新浪开发者ID
 *  @param redirectURI 微博开放平台第三方应用授权回调页地址
 *
 *  @return YES ? 成功 : 失败
 */
- (BOOL)registerApp:(NSString *)appid withRedirectURI:(NSString *)redirectURI;


/**
 *  @brief  处理新浪通过URL启动App时传递的数据
 *
 *  @param url 新浪启动第三方应用时传递过来的URL
 *
 *  @return YES ? 成功返回 : 失败返回
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/**
 *  @brief  新浪授权
 *
 *  @param mode           授权的形式
 *  @param handler        回调方法
 *
 *  @return YES ? 唤起成功 : 唤起失败
 */
- (BOOL)authWithMode:(DDSSAuthMode)mode
             handler:(DDSSAuthEventHandler)handler;

/**
 *  @brief  新浪分享
 *
 *  @param protocol       数据组装协议
 *  @param contentType    内容类型
 *  @param handler        回调
 *
 *  @return YES ? 唤起成功 ： 唤起失败
 */
- (BOOL)shareWithProtocol:(id<DDSocialShareContentProtocol>)protocol
              contentType:(DDSSContentType)contentType
                  handler:(DDSSShareEventHandler)handler;

@end
