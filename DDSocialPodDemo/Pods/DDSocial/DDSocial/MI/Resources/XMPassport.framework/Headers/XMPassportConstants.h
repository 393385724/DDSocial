//
//  XMPassportConstans.h
//  MiPassportFoundation
//
//  Created by 李 业 on 13-10-23.
//  Copyright (c) 2013年 Xiaomi. All rights reserved.
//


#define kXMPassportErrorDomain                          @"XMPassportErrorDomain"

#define    ERROR_CODE                                   @"code"
#define    ERROR_REASON                                 @"reason"
#define    ERROR_DESCRIPTION                            @"description"

#define XM_PAS_PARAM_KEY_USER                           @"user"
#define XM_PAS_PARAM_KEY_PWD                            @"pwd"
#define XM_PAS_PARAM_KEY_HASH                           @"hash"
#define XM_PAS_PARAM_KEY_SID                            @"sid"
#define XM_PAS_PARAM_KEY_CALLBACK                       @"callback"
#define XM_PAS_PARAM_KEY_CAPT_CODE                      @"captCode"
#define XM_PAS_PARAM_KEY_CAPT_URL                       @"captchaUrl"
#define XM_PAS_PARAM_KEY_CAPT_IMAGE                     @"captImage"

#define XM_PAS_PARAM_KEY_QUERY_STR                      @"qs"
#define XM_PAS_PARAM_KEY_SIGN                           @"_sign"
#define XM_PAS_PARAM_KEY_RETRUN_JSON                    @"_json"

#define XM_PAS_COOKIE_KEY_PASSTOKEN                     @"passToken"
#define XM_PAS_COOKIE_KEY_USERID                        @"userId"
#define XM_PAS_COOKIE_KEY_DEVICEID                      @"deviceId"
#define XM_PAS_COOKIE_KEY_CAPT_ICK                      @"ick"

// error code
#define ACCOUNT_DOMAIN_ONLINE  @"https://account.xiaomi.com"
#define ACCOUNT_DOMAIN_STAGING @"http://account.preview.n.xiaomi.net"

#define    XMPassportErrorCode_Success                                     0      //"成功"

#define    XMPassportErrorCode_ParamNotBlank                               -100    //"参数不能为空"
#define    XMPassportErrorCode_UnknownError                                -101    //未知错误
#define    XMPassportErrorCode_NoServiceToken                              -102    //没有返回serviceToken

#define    XMPassportErrorCode_SessionExpired                                -103   //session 过期
#define    XMPassportErrorCode_NoSignature                                 -104    //signature生成失败
#define    XMPassportErrorCode_NoConnection                                 -1009    //无连接
#define    XMPassportErrorCode_TimeOut                                      -1002   //request time out
#define    XMPassportErrorCode_HostNotFound                                 -1003   //无法连接服务器

#define    XMPassportErrorCode_WrongAuthority                             401    //权限错误, 请重新登录
#define    XMPassportErrorCode_UpdateVersionRequired                      402    //版本太低，强制升级
#define    XMPassportErrorCode_AccountIrregularity                        403    //帐号违规
#define    XMPassportErrorCode_NotFound                                   404    //“标准的notfound错误”
#define    XMPassportErrorCode_TemporaryBlocked                           405    //用户暂时被屏蔽

#define    XMPassportErrorCode_PassportVerifyFailed                       70016    //登录验证失败
#define    XMPassportErrorCode_PassportNeed2Step                          81003    //需要两步登陆
#define    XMPassportErrorCode_PassportPwdTooManyRetry                    87001    //密码尝试太多次，用户输入验证码

// 系统级错误代码
#define    XMPassportErrorCode_RemoteServiceError                          10003    //"远程服务错误"
