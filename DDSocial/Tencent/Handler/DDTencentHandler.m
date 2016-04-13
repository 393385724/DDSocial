//
//  DDTencentHandler.m
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDTencentHandler.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "DDSocialShareContentProtocol.h"

#import "UIImage+Zoom.h"

const CGFloat DDTencentThumbnailDataMaxSize = 1 * 1024.0 * 1024.0;
const CGFloat DDTencentImageDataMaxSize = 5 * 1024.0 * 1024.0;

@interface DDTencentHandler ()<TencentSessionDelegate,TencentApiInterfaceDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@property (nonatomic, assign) DDSSAuthMode authMode;
@property (nonatomic, copy) DDSSAuthEventHandler authEventHandler;

@property (nonatomic, assign) DDSSScene shareScene;
@property (nonatomic, copy) DDSSShareEventHandler shareEventHandler;

@end

@implementation DDTencentHandler

#pragma mark -判断QQ客户端是否安装
+ (BOOL)isQQInstalled{
    return [TencentOAuth iphoneQQInstalled];
}

#pragma mark -向QQ终端程序注册第三方应用
- (BOOL)registerApp:(NSString *)appid{
    if (![appid length]) {
        return NO;
    }
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:appid andDelegate:self];
    return YES;
}

#pragma mark -处理QQ通过URL启动App时传递的数据
- (BOOL)handleOpenURL:(NSURL *)url{
    if ([TencentOAuth CanHandleOpenURL:url]) {
        return [TencentOAuth HandleOpenURL:url];
    } else {
        return [QQApiInterface handleOpenURL:url delegate:self];
    }
}

#pragma mark -QQ授权逻辑
- (BOOL)authWithMode:(DDSSAuthMode)mode
             handler:(DDSSAuthEventHandler)handler{
    self.authMode = mode;
    self.authEventHandler = handler;
    if (self.authEventHandler) {
        self.authEventHandler(DDSSPlatformQQ, DDSSAuthStateBegan, nil, nil);
    }
    NSArray *permissions = @[kOPEN_PERMISSION_ADD_TOPIC,
                             kOPEN_PERMISSION_ADD_ONE_BLOG,
                             kOPEN_PERMISSION_ADD_ALBUM,
                             kOPEN_PERMISSION_UPLOAD_PIC,
                             kOPEN_PERMISSION_LIST_ALBUM,
                             kOPEN_PERMISSION_ADD_SHARE,
                             kOPEN_PERMISSION_CHECK_PAGE_FANS,
                             kOPEN_PERMISSION_GET_INFO,
                             kOPEN_PERMISSION_GET_OTHER_INFO,
                             kOPEN_PERMISSION_GET_VIP_INFO,
                             kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                             kOPEN_PERMISSION_GET_USER_INFO,
                             kOPEN_PERMISSION_GET_SIMPLE_USER_INFO];
    
    if ([TencentOAuth iphoneQQInstalled] && [TencentOAuth iphoneQQSupportSSOLogin]) {
        return [self.tencentOAuth authorize:permissions inSafari:NO];
    } else {
        return [self.tencentOAuth authorize:permissions inSafari:YES];
    }
}

#pragma mark -QQ分享
- (BOOL)shareWithProtocol:(id<DDSocialShareContentProtocol>)protocol
               shareScene:(DDSSScene)shareScene
              contentType:(DDSSContentType)contentType
                  handler:(DDSSShareEventHandler)handler{
    self.shareScene = shareScene;
    self.shareEventHandler = handler;
    if (self.shareEventHandler) {
        self.shareEventHandler(DDSSPlatformQQ, self.shareScene, DDSSShareStateBegan, nil);
    }

    if (contentType == DDSSContentTypeText && [protocol conformsToProtocol:@protocol(DDSocialShareTextProtocol)]) {
        return [self shareTextWithProtocol:(id<DDSocialShareTextProtocol>)protocol];
    } else if (contentType == DDSSContentTypeImage && [protocol conformsToProtocol:@protocol(DDSocialShareImageProtocol)]){
        return [self shareImageWithProtocol:(id<DDSocialShareImageProtocol>)protocol];
    } else if (contentType == DDSSContentTypeWebPage && [protocol conformsToProtocol:@protocol(DDSocialShareWebPageProtocol)]){
        return [self shareWebPageWithProtocol:(id<DDSocialShareWebPageProtocol>)protocol];
    } else {
        if (self.shareEventHandler) {
            NSString *errorDescription = [NSString stringWithFormat:@"share format error:%@ shareType:%lu",NSStringFromClass([protocol class]),(unsigned long)contentType];
            NSError *error = [NSError errorWithDomain:@"QQ Local Share Error" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
            self.shareEventHandler(DDSSPlatformQQ, self.shareScene, DDSSShareStateFail, error);
            self.shareEventHandler = nil;
        }
        return NO;
    }
}

#pragma mark - Private Methods

- (BOOL)shareTextWithProtocol:(id<DDSocialShareTextProtocol>)protocol{
    NSString *text = [protocol ddShareText];
    QQApiTextObject *textObject = [QQApiTextObject objectWithText:text];
    return [self sendApiObject:textObject];
}

- (BOOL)shareImageWithProtocol:(id<DDSocialShareImageProtocol>)protocol{
    NSData *imageData = [protocol ddShareImageWithImageData];
    NSData *thumbnailData = imageData;
    if ([protocol respondsToSelector:@selector(ddShareImageWithThumbnailData)]) {
        //optional
        thumbnailData = [protocol ddShareImageWithThumbnailData];
    }
    imageData = [UIImage imageData:imageData maxBytes:DDTencentImageDataMaxSize];
    thumbnailData = [UIImage imageData:thumbnailData maxBytes:DDTencentThumbnailDataMaxSize];
    
    NSString *title = [protocol ddShareImageWithTitle];
    NSString *descriptionString = [protocol ddShareImageWithDescription];
    NSString *webpageURL = [protocol ddShareImageWithWebpageUrl];
    
    if (self.shareScene == DDSSSceneQZone) {
        QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:webpageURL]
                                                               title:title
                                                         description:descriptionString
                                                    previewImageData:thumbnailData
                                                   targetContentType:QQApiURLTargetTypeNews];
        return [self sendApiObject:newsObject];
    } else {
        QQApiImageObject *imageObject = [QQApiImageObject objectWithData:imageData
                                                        previewImageData:thumbnailData
                                                                   title:title
                                                             description:descriptionString];
        return [self sendApiObject:imageObject];
    }
}

- (BOOL)shareWebPageWithProtocol:(id<DDSocialShareWebPageProtocol>)protocol{
    NSString *webpageURL = [protocol ddShareWebPageWithWebpageUrl];
    NSString *title = [protocol ddShareWebPageWithTitle];
    NSString *descriptionString = [protocol ddShareWebPageWithDescription];
    NSData *imageData = [protocol ddShareWebPageWithImageData];
    imageData = [UIImage imageData:imageData maxBytes:DDTencentThumbnailDataMaxSize];
    QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:webpageURL]
                                                           title:title
                                                     description:descriptionString
                                                previewImageData:imageData
                                               targetContentType:QQApiURLTargetTypeNews];
    return [self sendApiObject:newsObject];
}

- (BOOL)sendApiObject:(QQApiObject *)apiObject{
    SendMessageToQQReq *qqReq = [SendMessageToQQReq reqWithContent:apiObject];
    QQApiSendResultCode sendResult = EQQAPISENDSUCESS;
    if (self.shareScene == DDSSSceneQQFrined) {
        sendResult = [QQApiInterface sendReq:qqReq];
    } else {
        sendResult = [QQApiInterface SendReqToQZone:qqReq];
    }
    
    NSError *error = nil;
    switch (sendResult) {
        case EQQAPIQQNOTINSTALLED:{
            error = [NSError errorWithDomain:@"QQ Share Error" code:EQQAPIQQNOTINSTALLED userInfo:@{NSLocalizedDescriptionKey:@"QQ客户端未安装"}];
        }
            break;
        case EQQAPIQQNOTSUPPORTAPI_WITH_ERRORSHOW:
        case EQQAPIQQNOTSUPPORTAPI:{
            error = [NSError errorWithDomain:@"QQ Share Error" code:EQQAPIQQNOTSUPPORTAPI userInfo:@{NSLocalizedDescriptionKey:@"QQ不支持的API"}];
            break;
        }
        case EQQAPIMESSAGETYPEINVALID:{
            error = [NSError errorWithDomain:@"QQ Share Error" code:EQQAPIMESSAGETYPEINVALID userInfo:@{NSLocalizedDescriptionKey:@"分享类型不合法"}];
        }
            break;
        case EQQAPIMESSAGECONTENTNULL:{
            error = [NSError errorWithDomain:@"QQ Share Error" code:EQQAPIMESSAGECONTENTNULL userInfo:@{NSLocalizedDescriptionKey:@"分享内容为NULL"}];
        }
        case EQQAPIMESSAGECONTENTINVALID:{//失败
            error = [NSError errorWithDomain:@"QQ Share Error" code:EQQAPIMESSAGECONTENTINVALID userInfo:@{NSLocalizedDescriptionKey:@"分享内容不合法"}];
            break;
        }
        case EQQAPIAPPNOTREGISTED:{//失败
            error = [NSError errorWithDomain:@"QQ Share Error" code:EQQAPIAPPNOTREGISTED userInfo:@{NSLocalizedDescriptionKey:@"应用未注册"}];
        }
            break;
        case EQQAPISENDFAILD:{//失败
            error = [NSError errorWithDomain:@"QQ Share Error" code:EQQAPISENDFAILD userInfo:@{NSLocalizedDescriptionKey:@"请检查分享格式是否满足如下条件(如果有内容的话):\n1、文本分享\n(1)文本长度不能超过1536个字符\n2、多媒体分享\n(1)标题长度不能超过128个字符(2)描述内容长度不能超过512个字符(3)缩略图数据大小不能超过1M(4)图片真实数据内容大小不能超过5M(5)网页的url地址长度不能超过512个字符"}];
        }
            break;
        case EQQAPIQZONENOTSUPPORTTEXT:{//qzone分享不支持text类型分享
            error = [NSError errorWithDomain:@"QZone Share Error" code:EQQAPIQZONENOTSUPPORTTEXT userInfo:@{NSLocalizedDescriptionKey:@"qzone分享不支持text类型分享"}];
        }
            break;
        case EQQAPIQZONENOTSUPPORTIMAGE:{//qzone分享不支持image类型分享
            error = [NSError errorWithDomain:@"QZone Share Error" code:EQQAPIQZONENOTSUPPORTIMAGE userInfo:@{NSLocalizedDescriptionKey:@"qzone分享不支持image类型分享"}];
        }
            break;
        default:
            break;
    }
    if (error) {
        if (self.shareEventHandler) {
            self.shareEventHandler(DDSSPlatformQQ, self.shareScene, DDSSShareStateFail, error);
            self.shareEventHandler = nil;
        }
    }
    return sendResult == EQQAPISENDSUCESS;
}

#pragma mark - TencentLoginDelegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    if (self.authEventHandler) {
        self.authEventHandler(DDSSPlatformQQ, DDSSAuthStateSuccess, self.tencentOAuth, nil);
        self.authEventHandler = nil;
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (self.authEventHandler) {
        if (cancelled) {
            self.authEventHandler(DDSSPlatformQQ, DDSSAuthStateCancel, nil, nil);
        } else {
            NSError *error  = [NSError errorWithDomain:@"tencent login Error" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"登录失败"}];
            self.authEventHandler(DDSSPlatformQQ, DDSSAuthStateFail, nil, error);
        }
        self.authEventHandler = nil;
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    if (self.authEventHandler) {
        NSError *error  = [NSError errorWithDomain:@"tencent login Error" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"网络出错了"}];
        self.authEventHandler(DDSSPlatformQQ, DDSSAuthStateFail, nil, error);
        self.authEventHandler = nil;
    }
}

#pragma mark - QQApiInterfaceDelegate

- (void)onResp:(QQBaseResp *)resp{
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        NSInteger result = [resp.result integerValue];
        if (result == 0) {
            if (self.shareEventHandler) {
                self.shareEventHandler(DDSSPlatformQQ, self.shareScene, DDSSShareStateSuccess, nil);
            }
        } else if (result == -4) {
            if (self.shareEventHandler) {
                self.shareEventHandler(DDSSPlatformQQ, self.shareScene, DDSSShareStateCancel, nil);
            }
        } else {
            NSError *error = [NSError errorWithDomain:@"QQ Share Error" code:result userInfo:@{NSLocalizedDescriptionKey:resp.errorDescription}];
            if (self.shareEventHandler) {
                self.shareEventHandler(DDSSPlatformQQ, self.shareScene, DDSSShareStateFail, error);
            }
        }
        self.shareEventHandler = nil;
    }
}

- (void)onReq:(QQBaseReq *)req{
    //只是为了消除警告
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response{
    //只是为了消除警告
}

@end
