//
//  MLMessageRequest.h
//  MiLiaoAppSDK
//
//  Created by zhang weiliang on 13-4-24.
//  Copyright (c) 2013年 小米科技. All rights reserved.
//

#import "MLBaseRequest.h"
#import "MLMediaMessage.h"

typedef enum {
    SceneType_Chat = 0,     // 发送到米聊聊天，包括单聊和群聊
    SceneType_Wall,         // 发送到米聊广播
} SceneType;        // 消息发送的场景

@interface MLMessageRequest : MLBaseRequest
/*
 * text 发送文本消息的值，当bText为YES时有意义
 */
@property (nonatomic, strong) NSString *text;

/*
 * message 发送的富媒体消息，当bText为NO时有意义
 */
@property (nonatomic, strong) MLMediaMessage *message;

/*
 * bText 表明消息发送的类型是否为文本类型
 */
@property (nonatomic, assign) BOOL bText;

/*
 * scene 表明消息发送的场景，目前支持聊天和广播
 */
@property (nonatomic, assign) int scene;

@end
