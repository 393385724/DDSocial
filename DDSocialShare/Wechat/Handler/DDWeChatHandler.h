//
//  DDWeChatHandler.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialShareEventDefs.h"

@protocol DDSocialShareContentProtocol;
@class UIViewController;

@interface DDWeChatHandler : NSObject

/**
 *  @brief  判断微信客户端是否安装
 *
 *  @return YES ? 已经安装 : 未安装
 */
+ (BOOL)isWeChatInstalled;

/**
 *  @brief 向微信终端程序注册第三方应用
 * 需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现。
 *
 *  @param appid 微信开发者ID
 *  @param appDescription 应用附加信息，长度不超过1024字节
 *
 *  @return YES ? 成功 : 失败
 */
- (BOOL)registerApp:(NSString *)appid withDescription:(NSString *)appDescription;

/**
 *  @brief  处理微信通过URL启动App时传递的数据
 *
 *  @param url 微信启动第三方应用时传递过来的URL
 *
 *  @return YES ? 成功返回 : 失败返回
 */
- (BOOL)handleOpenURL:(NSURL *)url;

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
 *  @brief  微信分享
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

/**
 *  @brief  第三方通知微信，打开指定微信号profile页面
 *
 *  @param extMsg      如果用户加了该公众号为好友，extMsg会上传到服务器
 *  @param userName    跳转到该公众号的profile
 *  @param profileType 跳转的公众号类型
 *
 *  @return YES ? 成功 ： 失败
 */
- (BOOL)JumpToBizProfileWithExtMsg:(NSString *)extMsg
                          username:(NSString *)userName
                       profileType:(int)profileType;

@end
