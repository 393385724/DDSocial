//
//  MLBaseRequest.h
//  XiaomiFunction
//
//  Created by zhang weiliang on 12-12-19.
//  Copyright (c) 2012年 xiaomi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLBaseRequest : NSObject

/*
 * requestType 在MLRequestDefine.h中定义
 */
@property (nonatomic, assign) NSInteger requestType;

/*
 * uuid 指定米聊App中的登陆账号，如果uuid为nil时意味着任何登陆米聊的账号都支持
 */
@property (nonatomic, strong) NSString *uuid;

/*
 * targetMiliaoId 某些消息中有可能指定米聊中接受方的米聊id，如果为空，意味着不指定，需要手动选择
 */
@property (nonatomic, strong) NSString *targetMiliaoId;

/*
 * refer 具有统计意义，目前没有其他用处
 */
@property (nonatomic, strong) NSString *refer;

/*
 * url 是MLBaseRequest转换成为第三方APP或者米聊接收的url时的值，转换完成后才会有意义
 */
@property (nonatomic, strong) NSURL *url;

- (id)initWithUuid:(NSString *)uid
    targetMiliaoId:(NSString *)tid;

@end
