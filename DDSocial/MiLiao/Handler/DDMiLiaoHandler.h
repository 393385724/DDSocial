//
//  DDMiLiaoHandler.h
//  DDSocialDemo
//
//  Created by lilingang on 16/4/12.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialEventDefs.h"

@protocol DDSocialShareContentProtocol;
@protocol DDSocialHandlerProtocol;

@interface DDMiLiaoHandler : NSObject

/**
 *  @brief  判断米聊客户端是否安装
 *
 *  @return YES ? 已经安装 : 未安装
 */
+ (BOOL)isMiLiaoInstalled;

/**
 *  @brief 向米聊终端程序注册第三方应用
 *
 *  @return YES ? 成功 : 失败
 */
- (BOOL)registerApp;


/**
 *  @brief  处理米聊通过URL启动App时传递的数据
 *
 *  @param url 新浪启动第三方应用时传递过来的URL
 *
 *  @return YES ? 成功返回 : 失败返回
 */
- (BOOL)handleOpenURL:(NSURL *)url;

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
