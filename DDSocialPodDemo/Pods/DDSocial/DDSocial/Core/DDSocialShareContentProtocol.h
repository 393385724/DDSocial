//
//  DDSocialShareContentProtocol.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialTypeDefs.h"

@class UIImage;

@protocol DDSocialShareContentProtocol <NSObject>
@end

/**
 *  @brief  结构
 @code
 *texttexttexttexttexttexttexttexttexttexttext
 @endcode
 */
@protocol DDSocialShareTextProtocol<DDSocialShareContentProtocol>

/**
 *  @brief  消息的文本内容
 *
 *  @return 消息内容
 *  @note  字数长度不能超过 140
 */
- (NSString *)ddShareText;

@end

/**
 *  @brief  结构
 @code
 *texttexttexttexttexttexttexttexttexttexttexttext
 *
 ***********************
 ********image**********
 ***********************
 @endcode
 
 @code
 *texttexttexttexttexttexttexttexttexttexttexttext
 *
 ****************  title
 **imageData or**  description
 **ThumbnailData*  link
 @endcode
 */
@protocol DDSocialShareImageProtocol<DDSocialShareContentProtocol>

@required

/**
 *  @brief   标题
 */
- (NSString *)ddShareImageWithTitle;

/**
 *  @brief   原始图片 建议不要超过1M
 */
- (NSData *)ddShareImageWithImageData;

/**
 *  @brief   描述
 */
- (NSString *)ddShareImageWithDescription;

/**
 *  @brief  网页的URL地址
 */
- (NSString *)ddShareImageWithWebpageUrl;

@optional

/**
 *  @brief  消息的文本内容
 *
 *  @return  分享的内容文本
 *  @note  字数长度不能超过 140
 */
- (NSString *)ddShareImageText;

/**
 *  @brief   图片缩略图 不应超过32K
 */
- (NSData *)ddShareImageWithThumbnailData;

/**
 *  @brief   图片真实数据URL
 *
 */
- (NSString *)ddShareImageWithImageURL;

/**
 *  @brief   直接返回图片
 *
 *  @note  如果该方法和ddShareImageWithImageURL以及ddShareImageWithImageData同时实现了，优先使用该方法
 *
 */
- (UIImage *)ddShareImageWithUIImage;

@end

/**
 *  @brief  结构
 @code
 *texttexttexttexttexttexttexttexttexttexttexttext
 *
 ****************  title
 **imageData or**  description
 **ThumbnailData*  link
 @endcode
 */
@protocol DDSocialShareWebPageProtocol<DDSocialShareContentProtocol>

@required
/**
 *  @brief   标题
 */
- (NSString *)ddShareWebPageWithTitle;

/**
 *  @brief   内容描述
 */
- (NSString *)ddShareWebPageWithDescription;

/**
 *  @brief   图片缩略图 不应超过32K
 *
 */
- (NSData *)ddShareWebPageWithImageData;

/**
 *  @brief  网页的URL地址
 */
- (NSString *)ddShareWebPageWithWebpageUrl;

/**
 *  @brief   对象唯一ID，用于唯一标识一个多媒体内容
 *  @note only for sina
 */
- (NSString *)ddShareWebPageWithObjectID;

@optional
/**
 *  @brief  消息的文本内容
 *
 *  @return  分享的内容文本
 *  @note  字数长度不能超过 140
 */
- (NSString *)ddShareWebPageText;

/**
 *  @brief   多媒体内容缩略图URL
 */
- (NSString *)ddShareWebPageWithThumbnailURL;

/**
 *  @brief  判断场景是否使用图片形式
 *
 *  @param scence 分享场景
 *
 *  @return YES 使用图片形式分享 NO 使用默认webpage
 */
- (BOOL)ddShareWebPageByImageWithScence:(DDSSScene)scence;

@end