//
//  MLBaseResponse.h
//  MiLiaoAppSDK
//
//  Created by zhang weiliang on 13-4-27.
//  Copyright (c) 2013年 小米科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLBaseResponse : NSObject
/*
 * responseType 在MLResponseDefine.h中定义
 */
@property (nonatomic, assign) NSInteger responseType;

/*
 * errCode 在MLAppErrorDefine.h中定义
 */
@property (nonatomic, assign) NSInteger errCode;

/*
 * errDescription 在MLAppErrorDefine.h中定义
 */
@property (nonatomic, strong) NSString *errDescription;

/*
 * url 是MLBaseResponse转换成为第三方APP或者米聊接收的url时的值，转换完成后才会有意义
 */
@property (nonatomic, strong) NSURL *url;

@end
