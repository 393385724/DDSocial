//
//  MLLoginResponse.h
//  MiLiaoAppSDK
//
//  Created by zhang weiliang on 14-1-3.
//  Copyright (c) 2014年 小米科技. All rights reserved.
//

#import "MLBaseResponse.h"

@interface MLLoginResponse : MLBaseResponse

/*
 * sId MLoginRequest携带的sid，表明某个服务
 */
@property (nonatomic, strong) NSString *sId;

/*
 * serviceToken 登陆返回的字符串，用来代表某个服务sId的访问token
 */
@property (nonatomic, strong) NSString *serviceToken;

/*
 * serviceSecurity 登陆返回的字符串，访问加密所需
 */
@property (nonatomic, strong) NSString *serviceSecurity;

@end
