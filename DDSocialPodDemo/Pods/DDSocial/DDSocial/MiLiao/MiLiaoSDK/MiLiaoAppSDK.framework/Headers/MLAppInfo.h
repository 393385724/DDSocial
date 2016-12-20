//
//  MLAppInfo.h
//  MiLiaoAppSDK
//
//  Created by zhang weiliang on 14-1-15.
//  Copyright (c) 2014年 小米科技. All rights reserved.
//

@interface MLAppInfo : NSObject     // 用于描述app的data

/*
 * appId 指的是在小米注册的APPId
 */
@property (nonatomic, strong) NSString *appId;

/*
 * appName app名字
 */
@property (nonatomic, strong) NSString *appName;

/*
 * appPackageName android上的的包名
 */
@property (nonatomic, strong) NSString *appPackageName;

/*
 * appLocalUrl iphone上的scheme
 */
@property (nonatomic, strong) NSString *appLocalUrl;


+ (MLAppInfo *)appInfo;

@end
