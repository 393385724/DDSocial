//
//  MLAudioObject.h
//  MiLiaoAppSDK
//
//  Created by zhang weiliang on 13-4-18.
//  Copyright (c) 2013年 zhang weiliang. All rights reserved.
//

#define MIMETYPE_SPX              @"audio/x-speex"
#define MIMETYPE_MP3              @"audio/mp3"

@interface MLAudioObject : NSObject

/*
 * audioData 语音的真实数据，大小不能超过200k，只支持上面两种类型x-speex和MP3
 */
@property (nonatomic, strong) NSData *audioData;

/*
 * audioUrl 语音的外部链接，大小不能超过10k
 */
@property (nonatomic, strong) NSString *audioUrl;

/*
 * mimeType 语音的格式，支持两种，见上面的宏定义
 */
@property (nonatomic, strong) NSString *mimeType;

/*
 * playTime 语音的时长，和audioData搭配使用
 */
@property (nonatomic, assign) NSInteger playTime;

+ (MLAudioObject *)audioObject;

@end
