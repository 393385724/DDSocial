//
//  DDSocialTypeDefs.h.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#ifndef DDSocialTypeDefs_h
#define DDSocialTypeDefs_h

/**
 *  @brief  定义了第三方平台
 */
typedef NS_ENUM(NSUInteger, DDSSPlatform) {
    DDSSPlatformNone = 0,
    DDSSPlatformWeChat,        //**< 微信      */
    DDSSPlatformQQ,            //**< QQ客户端   */
    DDSSPlatformSina,          //**< 新浪微博   */
    DDSSPlatformMI,            //**< 小米       */
    DDSSPlatformFacebook,      //**< Facebook  */
    DDSSPlatformTwitter,       //**< Twitter  */
    DDSSPlatformGoogle,        //**< Google    */
    DDSSPlatformLine,          //**< Line    */
    DDSSPlatformInstagram,     //**< Instagram  */
    DDSSPlatformCount,         //**< 计数使用   */
};

/**
 *  @brief  定义了授权的方式
 */
typedef NS_ENUM(NSUInteger, DDSSAuthMode) {
    DDSSAuthModeCode = 0,    //**< code形式      */
    DDSSAuthModeToken,       //**< token形式     */
};

/**
 *	@brief	定义了三方授权过程中的状态
 */
typedef NS_ENUM(NSUInteger, DDSSAuthState) {
    DDSSAuthStateBegan = 0,   /**< 开始 */
    DDSSAuthStateSuccess,     /**< 成功 */
    DDSSAuthStateFail,        /**< 失败 */
    DDSSAuthStateCancel,      /**< 取消 */
};

/**
 *  @brief  定义了第三方分享的场景
 */
typedef NS_ENUM(NSUInteger, DDSSScene) {
    DDSSSceneWXSession,     /**< 聊天界面       */
    DDSSSceneWXTimeline,    /**< 朋友圈         */
    DDSSSceneQQFrined,      /**< QQ好友         */
    DDSSSceneQZone,         /**< QQ空间         */
    DDSSSceneSina,          /**< 新浪微博        */
    DDSSSceneFacebook,      /**< Facebook       */
    DDSSSceneTwitter,       /**< Twitter         */
    DDSSSceneLine,          /**< Line           */
    DDSSSceneInstagram,     /**< Instagram      */
};

/**
 *  @brief  定义了第三方分享类型
 */
typedef NS_ENUM(NSUInteger, DDSSContentType) {
    DDSSContentTypeText,        /**< 纯文本 */
    DDSSContentTypeImage,       /**< 图片 */
    DDSSContentTypeWebPage,     /**< 网页 */
};

/**
 *	@brief	第三方分享过程中的状态
 */
typedef NS_ENUM(NSUInteger, DDSSShareState) {
    DDSSShareStateBegan = 0,    /**< 开始 */
    DDSSShareStateSuccess,      /**< 成功 */
    DDSSShareStateFail,         /**< 失败 */
    DDSSShareStateCancel,       /**< 取消 */
};


#endif /* DDSocialTypeDefs_h */
