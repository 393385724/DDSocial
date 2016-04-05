//
//  DDSocialShareEventDefs.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#ifndef DDSocialShareEventDefs_h
#define DDSocialShareEventDefs_h
#import "DDSocialShareTypeDefs.h"

/**
 *  @brief  授权事件处理器
 *
 *  @param platform 授权平台
 *  @param state    授权状态
 *  @param result   返回结果
 *  @param error    授权错误信息
 */
typedef void(^DDSSAuthEventHandler) (DDSSPlatform platform, DDSSAuthState state, id result, NSError *error);

/**
 *	@brief	分享内容事件处理器
 *
 *  @param platform   分享平台
 *  @param scene      分享场景
 *  @param state      分享状态
 *  @param error      分享错误信息
 */
typedef void(^DDSSShareEventHandler) (DDSSPlatform platform, DDSSScene scene, DDSSShareState state, NSError *error);

#endif /* DDSocialShareEventDefs_h */
