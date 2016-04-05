//
//  DDTencentHandler.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialEventDefs.h"

@protocol DDSocialShareContentProtocol;

@interface DDTencentHandler : NSObject

/**
 *  @brief  判断用户手机上是否安装手机QQ
 *
 *  @return YES ? 已经安装 : 未安装
 */
+ (BOOL)isQQInstalled;

/**
 *  @brief 向QQ终端程序注册第三方应用
 * 需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现。
 *
 *  @param appid Tencent开发者ID
 *
 *  @return YES ? 成功 : 失败
 */
- (BOOL)registerApp:(NSString *)appid;


/**
 *  @brief  处理QQ通过URL启动App时传递的数据
 *
 *  @param url QQ启动第三方应用时传递过来的URL
 *
 *  @return YES ? 成功返回 : 失败返回
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/**
 *  @brief  QQ授权
 *
 *  @param mode           授权的形式
 *  @param handler        回调方法
 *
 *  @return YES ? 唤起成功 : 唤起失败
 */
- (BOOL)authWithMode:(DDSSAuthMode)mode
             handler:(DDSSAuthEventHandler)handler;

/**
 *  @brief  分享内容
 *
 *  @param protocol       数据组装协议
 *  @param shareScene     分享场景
 *  @param contentType    内容类型
 *  @param handler        回调
 *
 *  @return YES ? 唤起成功 ： 唤起失败
 */
- (BOOL)shareWithProtocol:(id<DDSocialShareContentProtocol>)protocol
               shareScene:(DDSSScene)shareScene
              contentType:(DDSSContentType)contentType
                  handler:(DDSSShareEventHandler)handler;

@end
