//
//  MLLoginRequest.h
//  MiLiaoAppSDK
//
//  Created by zhang weiliang on 14-1-3.
//  Copyright (c) 2014年 小米科技. All rights reserved.
//

#import "MLBaseRequest.h"

@interface MLLoginRequest : MLBaseRequest
/*
 * sId 换取serviceToken所需的sid，表明serviceToken所代表的服务id
 */
@property (nonatomic, strong) NSString *sId;

/*
 * callBackUrl 换取serviceToken所需的回调给服务提供者的url
 */
@property (nonatomic, strong) NSString *callBackUrl;

- (id)initWithUuid:(NSString *)uid
    targetMiliaoId:(NSString *)tid
               sId:(NSString *)sid
       callBackUrl:(NSString *)callBackUrl;

@end
