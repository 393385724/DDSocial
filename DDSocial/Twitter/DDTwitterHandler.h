//
//  DDTwitterHandler.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialEventDefs.h"

@protocol DDSocialShareContentProtocol;
@class UIViewController;

@interface DDTwitterHandler : NSObject

/**
 *  @brief  判断用户手机上是否登录Twitter(使用内置Twitter分享必须判断有没有登录)
 *
 *  @return YES ? 已经安装 : 未安装
 */
+ (BOOL)isTwitterInstalled;

/**
 *  @brief  分享内容
 *
 *  @param viewController 当前的ViewController
 *  @param protocol       数据组装协议
 *  @param contentType    内容类型
 *  @param handler        回调
 *
 *  @return YES ? 唤起成功 ： 唤起失败
 */
- (BOOL)shareWithViewController:(UIViewController *)viewController
                       protocol:(id<DDSocialShareContentProtocol>)protocol
                    contentType:(DDSSContentType)contentType
                        handler:(DDSSShareEventHandler)handler;

@end
