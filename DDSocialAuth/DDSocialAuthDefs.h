//
//  DDSocialAuthDefs.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#ifndef DDSocialAuthDefs_h
#define DDSocialAuthDefs_h

@class DDAuthItem;

/**
 *  @brief  定义了第三方平台
 */
typedef NS_ENUM(NSUInteger, DDAuthPlatform) {
    DDAuthPlatformNone = 0,
    DDAuthPlatformWeChat,       //**< 微信      */
    DDAuthPlatformQQ,           //**< QQ客户端   */
    DDAuthPlatformSina,         //**< 新浪微博   */
    DDAuthPlatformFacebook,     //**< Facebook  */
    DDAuthPlatformTwitter,      //**< Twitter   */
    DDAuthPlatformMI,           //**< 小米账号   */
};


typedef NS_ENUM(NSUInteger, DDAuthState) {
    DDAuthStateBegan = 0,   /**< 开始 */
    DDAuthStateSuccess,     /**< 成功 */
    DDAuthStateFail,        /**< 失败 */
    DDAuthStateCancel,      /**< 取消 */
};

typedef NS_ENUM(NSUInteger, DDAuthMode) {
    DDAuthModeCode,      /**< code形式 */
    DDAuthModeToken,     /**< token形式 */
};



typedef void(^DDAuthEventHandler) (DDAuthPlatform platform, DDAuthState state, DDAuthItem *authItem, NSError *error);


#endif /* DDSocialAuthDefs_h */
