//
//  DDSocialHandlerProtocol.h
//  Pods
//
//  Created by CocoaBob on 18/04/16.
//
//

#import <Foundation/Foundation.h>
#import "DDSocialEventDefs.h"
#import "DDSocialTypeDefs.h"

@protocol DDSocialShareContentProtocol;
@class DDAuthItem;
@class DDLinkupItem;

@protocol DDSocialHandlerProtocol <NSObject>

@optional
/**
 *  @brief 判断客户端是否安装
 *
 *  @return YES ? 已安装 : 未安装
 */
+ (BOOL)isInstalled;

/**
 *  @brief  在app启动的时候调用,完成第三方应用的注册
 *  @code
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 *  @endcode
 *
 *  @param appKey      线下申请的appKey,没有则不传
 *  @param appSecret   线下申请的appSecret,没有则不传
 *  @param redirectURL 线下填写的redirectURL,没有则不传
 *  @param appDescription app描述,没有则不传
 */
- (void)registerWithAppKey:(NSString *)appKey
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
 *  @brief  三方授权返回授权信息
 *
 *  @param authMode       授权的形式
 *  @param viewController 当前ViewController
 *  @param handler        回调方法
 *
 *  @return YES ? 唤起成功 : 唤起失败
 */
- (BOOL)authWithMode:(DDSSAuthMode)authMode
          controller:(UIViewController *)viewController
             handler:(DDSSAuthEventHandler)handler;

/**
 *  @brief 获取用户个人信息
 *
 *  @param authItem 授权信息model
 *  @param handler  回调
 *
 *  @return YES ? 发起成功 : 发起失败
 */
- (BOOL)getUserInfoWithAuthItem:(DDAuthItem *)authItem
                        handler:(DDSSUserInfoEventHandler)handler;


/**
 *  @brief  分享到第三方平台
 *
 *  @param viewController 当前的Controller
 *  @param shareScene     分享的场景
 *  @param contentType    分享数据类型
 *  @param protocol       遵循分享的数据组装的对象
 *  @param handler        回调方法
 *
 *  @return YES ? 唤起成功 : 唤起失败
 */
- (BOOL)shareWithController:(UIViewController *)viewController
                 shareScene:(DDSSScene)shareScene
                contentType:(DDSSContentType)contentType
                   protocol:(id<DDSocialShareContentProtocol>)protocol
                    handler:(DDSSShareEventHandler)handler;

/**
 *  @brief 三方数据接入
 *
 *  @param linkupItem 与第三方沟通需要的信息模型
 *
 *  @return YES ? 成功 : 失败
 */
- (BOOL)linkupWithItem:(DDLinkupItem *)linkupItem;

@end