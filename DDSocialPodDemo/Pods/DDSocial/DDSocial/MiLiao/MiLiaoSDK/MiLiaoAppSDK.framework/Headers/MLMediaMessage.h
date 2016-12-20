//
//  MLMediaMessage.h
//  MiLiaoAppSDK
//
//  Created by zhang weiliang on 13-4-18.
//  Copyright (c) 2013年 zhang weiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLMediaMessage : NSObject

/*
 * title 富媒体消息的标题
 */
@property (nonatomic, strong) NSString *title;

/*
 * description 富媒体消息的描述或者内容
 */
@property (nonatomic, strong) NSString *description;

/*
 * thumbData 富媒体消息的缩略图，对于语音消息如果有缩略图的情况可以在此设置
 */
@property (nonatomic, strong) NSData *thumbData;

/*
 * multiObject 消息富媒体对象，包括图片（MLImageObject）、音频(MLAudioObject)或者APP扩展(MLAppExtendObject)
 */
@property (nonatomic, strong) id multiObject;

/*
 * unSupportText 对于不支持此类消息所显示的信息
 */
@property (nonatomic, strong) NSString *unSupportText;

/*
 * 设置富媒体消息的缩略图，大小不超过15K
 */
- (void)setThumbImage:(UIImage *)thumbImage;

@end
