//
//  MLAppExtendObject.h
//  MiLiaoAppSDK
//
//  Created by zhang weiliang on 13-4-18.
//  Copyright (c) 2013年 zhang weiliang. All rights reserved.
//

#import "MLAppInfo.h"

@interface MLAppExtendObject : NSObject

/*
 * vipId 如果有vip账号的话，vip账号的ID
 */
@property (nonatomic, strong) NSString *vipId;

/*
 * vipName 如果有vip账号的话，vip账号的名字
 */
@property (nonatomic, strong) NSString *vipName;

/*
 * webUrl 如果有网页的话，网页的url，大小不超过10k
 */
@property (nonatomic, strong) NSString *webUrl;

/*
 * arrMultiObj 其他的Object的聚合，包括MLAudioObject, MLImageObject
 */
@property (nonatomic, strong) NSArray  *arrMultiObj;

/*
 * appInfo 消息中携带的第三方App的详细信息
 */
@property (nonatomic, strong) MLAppInfo *appInfo;


+ (MLAppExtendObject *)extendObject;

@end
