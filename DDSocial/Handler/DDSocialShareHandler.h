//
//  DDSocialShareHandler.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialEventDefs.h"
#import "DDSocialShareContentProtocol.h"
#import "DDLinkupItem.h"
#import "DDAuthItem.h"

@class UIApplication;
@class UIViewController;

/**
 *  @brief  社会化分享组件统一接口，单例
 */
@interface DDSocialShareHandler : NSObject

/**
 *  @brief  唯一初始化方法
 *
 *  @return DDSocialShareHandler 对象
 */
+ (DDSocialShareHandler *)sharedInstance;


/**
 *  @brief 判断客户端是否安装
 *
 *  @param platform 各应用平台
 *
 *  @return YES ? 已安装 : 未安装
 */
+ (BOOL)isInstalledPlatform:(DDSSPlatform)platform;

/**
 *  @brief  判断分享场景是否可用
 *
 *  @param scene DDSSScene
 *
 *  @return YES ? 已安装 : 未安装
 */
+ (BOOL)canShareToScence:(DDSSScene)scene;

/**
 *  @brief  在app启动的时候调用,完成第三方应用的注册
 *  @code
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 *  @endcode
 *
 *  @param platform    各应用平台
 */
- (void)registerPlatform:(DDSSPlatform)platform;

/**
 *  @brief  在app启动的时候调用,完成第三方应用的注册
 *  @code
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 *  @endcode
 *
 *  @param platform    各应用平台
 *  @param appKey      线下申请的appKey,必传参数
 */
- (void)registerPlatform:(DDSSPlatform)platform
                  appKey:(NSString *)appKey;

/**
 *  @brief  在app启动的时候调用,完成第三方应用的注册
 *  @code
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 *  @endcode
 *
 *  @param platform    各应用平台
 *  @param appKey      线下申请的appKey,必传参数
 *  @param appSecret   线下申请的appSecret,没有则不传
 */
- (void)registerPlatform:(DDSSPlatform)platform
                  appKey:(NSString *)appKey
               appSecret:(NSString *)appSecret;

/**
 *  @brief  在app启动的时候调用,完成第三方应用的注册
 *  @code
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 *  @endcode
 *
 *  @param platform    各应用平台
 *  @param appKey      线下申请的appKey,必传参数
 *  @param redirectURL 线下填写的redirectURL,没有则不传
 */
- (void)registerPlatform:(DDSSPlatform)platform
                  appKey:(NSString *)appKey
             redirectURL:(NSString *)redirectURL;

/**
 *  @brief  在app启动的时候调用,完成第三方应用的注册
 *  @code
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 *  @endcode
 *
 *  @param platform    各应用平台
 *  @param appKey      线下申请的appKey,必传参数
 *  @param appSecret   线下申请的appSecret,没有则不传
 *  @param redirectURL 线下填写的redirectURL,没有则不传
 *  @param appDescription app描述,没有则不传
 */
- (void)registerPlatform:(DDSSPlatform)platform
                  appKey:(NSString *)appKey
               appSecret:(NSString *)appSecret
             redirectURL:(NSString *)redirectURL
          appDescription:(NSString *)appDescription;


/**
 *  @brief  处理请求打开链接,如果集成新浪微博(SSO)、Facebook(SSO)、微信、QQ分享功能需要加入此方法
 *  @code
 *   - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
 *  @endcode
 *
 *  @param application       当前应用
 *  @param url               链接
 *  @param sourceApplication 源应用
 *  @param annotation        源应用提供的信息
 *
 *	@return	YES ? 表示接受请求 : 表示不接受请求
 */
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

/**
 *  @brief  处理第三方通过指定URL唤起app时传递的数据
 *  @code
 - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
 *  @endcode
 *
 *  @param app     自己的application
 *  @param url     传递的URL资源
 *  @param options app launch时的参数
 *
 *  @return YES ? 唤起成功 : 唤起失败
 */
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options;

/**
 *  @brief  三方授权返回授权信息
 *
 *  @param platform       各应用平台
 *  @param authMode       授权的形式
 *  @param viewController 当前ViewController
 *  @param handler        回调方法
 *
 *  @return YES ? 唤起成功 : 唤起失败
 */
- (BOOL)authWithPlatform:(DDSSPlatform)platform
                authMode:(DDSSAuthMode)authMode
              controller:(UIViewController *)viewController
                 handler:(DDSSAuthEventHandler)handler;

/**
 *  @brief 获取用户个人信息
 *
 *  @param platform 各应用平台
 *  @param authItem 授权信息model
 *  @param handler  回调
 *
 *  @return YES ? 发起成功 : 发起失败
 */
- (BOOL)getUserInfoWithPlatform:(DDSSPlatform)platform
                       authItem:(DDAuthItem *)authItem
                        handler:(DDSSUserInfoEventHandler)handler;

/**
 *  @brief  分享到第三方平台
 *
 *  @param platform       各平台应用
 *  @param viewController 当前的Controller
 *  @param shareScene     分享的场景
 *  @param contentType    分享数据类型
 *  @param protocol       遵循分享的数据组装的对象
 *  @param handler        回调方法
 *
 *  @return YES ? 唤起成功 : 唤起失败
 */
- (BOOL)shareWithPlatform:(DDSSPlatform)platform
               controller:(UIViewController *)viewController
               shareScene:(DDSSScene)shareScene
              contentType:(DDSSContentType)contentType
                 protocol:(id<DDSocialShareContentProtocol>)protocol
                  handler:(DDSSShareEventHandler)handler;

/**
 *  第三方接入
 *
 *  @param platform       各平台应用
 *  @param linkupItem     与第三方沟通需要的信息模型
 *
 *  @return 成功返回YES,失败返回 NO
 */
- (BOOL)linkupWithPlatform:(DDSSPlatform)platform
                      item:(DDLinkupItem *)linkupItem;


@end
