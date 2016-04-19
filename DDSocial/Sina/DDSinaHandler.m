//
//  DDSinaHandler.m
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDSinaHandler.h"
#import <WeiboSDK/WeiboSDK.h>

#import "DDAuthItem.h"
#import "DDUserInfoItem.h"

#import "DDSocialShareContentProtocol.h"

#import "DDSoicalRequestHandler.h"

#import "UIImage+Zoom.h"

const CGFloat DDSinaThumbnailDataMaxSize = 32 * 1024.0;
const CGFloat DDSinaImageDataMaxSize = 5 * 1024 * 1024;

@interface DDSinaHandler ()<WeiboSDKDelegate>

@property (nonatomic, copy) NSString *appkey;
@property (nonatomic, copy) NSString *redirectURI;

@property (nonatomic, assign) DDSSAuthMode authMode;
@property (nonatomic, copy) DDSSAuthEventHandler authEventHandler;

@property (nonatomic, copy) DDSSShareEventHandler shareEventHandler;

@end

@implementation DDSinaHandler

#pragma mark - Private Methods

- (BOOL)shareTextWithProtocol:(id<DDSocialShareTextProtocol>)protocol{
    WBMessageObject *message = [WBMessageObject message];
    message.text = [protocol ddShareText];
    return [self sendWithMessage:message];
}

- (BOOL)shareImageWithProtocol:(id<DDSocialShareImageProtocol>)protocol{
    WBImageObject *imageObject = [WBImageObject object];
    NSData *imageData = [protocol ddShareImageWithImageData];
    imageObject.imageData = [UIImage imageData:imageData maxBytes:DDSinaImageDataMaxSize];
    WBMessageObject *message = [WBMessageObject message];
    if ([protocol respondsToSelector:@selector(ddShareImageText)]) {
        message.text = [protocol ddShareImageText];
    }
    message.imageObject = imageObject;
    return [self sendWithMessage:message];
}

- (BOOL)shareWebPageWithProtocol:(id<DDSocialShareWebPageProtocol>)protocol{
    BOOL useImage = NO;
    if ([protocol respondsToSelector:@selector(ddShareWebPageByImageWithScence:)]) {
        useImage = [protocol ddShareWebPageByImageWithScence:DDSSSceneSina];
    }
    WBMessageObject *message = [WBMessageObject message];
    if (useImage) {
        WBImageObject *imageObject = [WBImageObject object];
        NSData *imageData = [protocol ddShareWebPageWithImageData];
        imageObject.imageData = [UIImage imageData:imageData maxBytes:DDSinaImageDataMaxSize];
        NSString *shareText = @"";
        if ([protocol respondsToSelector:@selector(ddShareImageText)]) {
            NSString *text = [protocol ddShareWebPageText];
            if ([text length] && text) {
                shareText = [shareText stringByAppendingString:text];
            }
        }
        NSString *title = [protocol ddShareWebPageWithTitle];
        if ([title length] && title) {
            shareText = [shareText stringByAppendingString:title];
        }
        NSString *descriptionString = [protocol ddShareWebPageWithDescription];
        if ([descriptionString length] && descriptionString) {
            shareText = [shareText stringByAppendingString:descriptionString];
        }
        NSString *webpageUrl = [protocol ddShareWebPageWithWebpageUrl];
        if ([webpageUrl length] && webpageUrl) {
            shareText = [shareText stringByAppendingString:webpageUrl];
        }
        message.text = shareText;
        message.imageObject = imageObject;
    } else {
        WBWebpageObject *webPageObject = [WBWebpageObject object];
        webPageObject.objectID = [protocol ddShareWebPageWithObjectID];
        webPageObject.title = [protocol ddShareWebPageWithTitle];
        webPageObject.description = [protocol ddShareWebPageWithDescription];
        NSData *imageData = [protocol ddShareWebPageWithImageData];
        webPageObject.thumbnailData = [UIImage imageData:imageData maxBytes:DDSinaThumbnailDataMaxSize];
        webPageObject.webpageUrl = [protocol ddShareWebPageWithWebpageUrl];
        
        message.mediaObject = webPageObject;
        if ([protocol respondsToSelector:@selector(ddShareWebPageText)]) {
            message.text = [protocol ddShareWebPageText];
        }
    }
    return [self sendWithMessage:message];
}

- (BOOL)sendWithMessage:(WBMessageObject *)message{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = self.redirectURI;
    authRequest.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    BOOL sendSuccess = [WeiboSDK sendRequest:request];
    if (!sendSuccess) {
        if (self.shareEventHandler) {
            NSError *error = [NSError errorWithDomain:@"Sina Local Share Error" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"请检查分享格式是否满足如下条件(如果有内容的话):\n1、文本分享\n(1)文本长度不能超过140个汉字\n2、多媒体分享\n(1)标题长度不能超过1K(2)描述内容长度不能超过1K(3)缩略图数据大小不能超过32K(4)图片真实数据内容大小不能超过10M(5)网页的url地址长度不能超过225"}];
            self.shareEventHandler(DDSSPlatformSina, DDSSSceneSina, DDSSShareStateFail, error);
            self.shareEventHandler = nil;
        }
    }
    return sendSuccess;
}

#pragma mark - WeiboSDKDelegate
/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        WeiboSDKResponseStatusCode statusCode = response.statusCode;
        switch (statusCode) {
            case WeiboSDKResponseStatusCodeSuccess: {
                if (self.authEventHandler) {
                    NSDictionary *userInfo = response.userInfo;
                    DDAuthItem *authItem = [DDAuthItem new];
                    authItem.thirdToken = userInfo[@"access_token"];
                    authItem.thirdId = userInfo[@"uid"];
                    authItem.rawObject = response;
                    self.authEventHandler(DDSSPlatformSina, DDSSAuthStateSuccess, authItem, nil);
                }
                break;
            }
            case WeiboSDKResponseStatusCodeUserCancel: {
                if (self.authEventHandler) {
                    self.authEventHandler(DDSSPlatformSina, DDSSAuthStateCancel, nil, nil);
                }
                break;
            }
            case WeiboSDKResponseStatusCodeSentFail:
            case WeiboSDKResponseStatusCodeAuthDeny:
            case WeiboSDKResponseStatusCodeUnsupport:
            case WeiboSDKResponseStatusCodeUnknown: {
                if (self.authEventHandler) {
                    NSError *error = [NSError errorWithDomain:@"sina Auth error" code:statusCode userInfo:@{NSLocalizedDescriptionKey:@"授权失败"}];
                    self.authEventHandler(DDSSPlatformSina, DDSSAuthStateFail, nil, error);
                }
                break;
            }
            default: {
                break;
            }
        }
        self.authEventHandler = nil;
        
    } else if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]){
        WeiboSDKResponseStatusCode statusCode = response.statusCode;
        switch (statusCode) {
            case WeiboSDKResponseStatusCodeSuccess: {
                if (self.shareEventHandler) {
                    self.shareEventHandler(DDSSPlatformSina, DDSSSceneSina, DDSSShareStateSuccess, nil);
                }
                break;
            }
            case WeiboSDKResponseStatusCodeUserCancel: {
                if (self.shareEventHandler) {
                    self.shareEventHandler(DDSSPlatformSina, DDSSSceneSina, DDSSShareStateCancel, nil);
                }
                break;
            }
            case WeiboSDKResponseStatusCodeSentFail:
            case WeiboSDKResponseStatusCodeAuthDeny:
            case WeiboSDKResponseStatusCodeUnsupport:
            case WeiboSDKResponseStatusCodeUnknown: {
                if (self.shareEventHandler) {
                    NSError *error = [NSError errorWithDomain:@"Sina Share error" code:statusCode userInfo:@{NSLocalizedDescriptionKey:@"分享失败"}];
                    self.shareEventHandler(DDSSPlatformSina, DDSSSceneSina, DDSSShareStateFail, error);
                }
                break;
            }
            default: {
                break;
            }
        }
        self.shareEventHandler = nil;
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    //没用吧 防止警告
}

@end

@implementation DDSinaHandler (DDSocialHandlerProtocol)

+ (BOOL)isInstalled {
    return [WeiboSDK isWeiboAppInstalled];
}

- (BOOL)registerWithAppKey:(NSString *)appKey
                 appSecret:(NSString *)appSecret
               redirectURL:(NSString *)redirectURL
            appDescription:(NSString *)appDescription {
    NSAssert(appKey, @"appkey 必须不能为空");
    self.appkey = appKey;
    self.redirectURI = redirectURL;
    return [WeiboSDK registerApp:appKey];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)authWithMode:(DDSSAuthMode)mode
          controller:(UIViewController *)viewController
             handler:(DDSSAuthEventHandler)handler {
    self.authMode = mode;
    self.authEventHandler = handler;
    
    if (self.authEventHandler) {
        self.authEventHandler(DDSSPlatformSina, DDSSAuthStateBegan, nil, nil);
    }
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = self.redirectURI;
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    request.scope = @"all";
    return [WeiboSDK sendRequest:request];
}

- (BOOL)getUserInfoWithAuthItem:(DDAuthItem *)authItem
                        handler:(DDSSUserInfoEventHandler)handler{
    if (!handler || !authItem) {
        return NO;
    }
    NSDictionary *dict = @{@"source":self.appkey,
                           @"access_token":authItem.thirdToken,
                           @"uid":authItem.thirdId};
    [DDSoicalRequestHandler sendAsynWithURL:@"https://api.weibo.com/2/users/show.json" params:dict completeHandle:^(NSDictionary *responseDict, NSError *connectionError) {
        if (connectionError) {
            handler(nil, connectionError);
        } else {
            NSInteger errorCode = [responseDict[@"error_code"] integerValue];
            if (errorCode) {
                NSString *errorMessage = responseDict[@"error"];
                NSError *error = [NSError errorWithDomain:@"Sina Error" code:errorCode userInfo:@{@"description":errorMessage}];
                handler(nil,error);
            } else {
                DDUserInfoItem *userItem = [[DDUserInfoItem alloc] initWithPlatForm:DDSSPlatformSina rawObject:responseDict];
                handler(userItem,nil);
            }
        }
    }];
    return YES;
}

- (BOOL)shareWithController:(UIViewController *)viewController
                 shareScene:(DDSSScene)shareScene
                contentType:(DDSSContentType)contentType
                   protocol:(id<DDSocialShareContentProtocol>)protocol
                    handler:(DDSSShareEventHandler)handler {
    if (!handler) {
        return NO;
    }
    self.shareEventHandler = handler;
    
    self.shareEventHandler(DDSSPlatformSina, DDSSSceneSina, DDSSShareStateBegan, nil);
    
    if (contentType == DDSSContentTypeText && [protocol conformsToProtocol:@protocol(DDSocialShareTextProtocol)]) {
        return [self shareTextWithProtocol:(id<DDSocialShareTextProtocol>)protocol];
    } else if (contentType == DDSSContentTypeImage && [protocol conformsToProtocol:@protocol(DDSocialShareImageProtocol)]){
        return [self shareImageWithProtocol:(id<DDSocialShareImageProtocol>)protocol];
    } else if (contentType == DDSSContentTypeWebPage && [protocol conformsToProtocol:@protocol(DDSocialShareWebPageProtocol)]){
        return [self shareWebPageWithProtocol:(id<DDSocialShareWebPageProtocol>)protocol];
    } else {
        NSString *errorDescription = [NSString stringWithFormat:@"分享格式错误:%@ shareType:%lu",NSStringFromClass([protocol class]),(unsigned long)contentType];
        NSError *error = [NSError errorWithDomain:@"Sina Share Error" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
        self.shareEventHandler(DDSSPlatformSina, DDSSSceneSina, DDSSShareStateFail, error);
        self.shareEventHandler = nil;
        return NO;
    }
}

- (BOOL)linkupWithItem:(DDLinkupItem *)linkupItem{
    return NO;
}

@end
