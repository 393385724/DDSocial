//
//  DDMiLiaoHandler.m
//  DDSocialDemo
//
//  Created by lilingang on 16/4/12.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDMiLiaoHandler.h"

#import <MiLiaoAppSDK/MLAppApi.h>
#import <MiLiaoAppSDK/MLImageObject.h>
#import <MiLiaoAppSDK/MLMediaMessage.h>
#import <MiLiaoAppSDK/MLMessageRequest.h>
#import <MiLiaoAppSDK/MLAppExtendObject.h>
#import <MiLiaoAppSDK/MLLoginRequest.h>
#import <MiLiaoAppSDK/MLAppErrorDefine.h>

#import "DDSocialShareContentProtocol.h"
#import "DDSocialHandlerProtocol.h"
#import "UIImage+Zoom.h"

CGFloat const DDMiLiaoThumbnailDataMaxSize = 15 * 1024.0;
CGFloat const DDMiLiaoImageDataMaxSize = 200 * 1024.0;

@interface DDMiLiaoHandler()<MLAppApiDelgate>

@property (nonatomic, assign) DDSSScene shareScene;
@property (nonatomic, copy) DDSSShareEventHandler shareEventHandler;

@end

@implementation DDMiLiaoHandler

#pragma mark - Private Methods

- (BOOL)shareTextWithProtocol:(id<DDSocialShareTextProtocol>)protocol{
    NSString *text = [protocol ddShareText];
    return [self sendWithText:text mediaMessage:nil];
}

- (BOOL)shareImageWithProtocol:(id<DDSocialShareImageProtocol>)protocol{
    MLImageObject *ext = [MLImageObject imageObject];
    NSData *imageData = [protocol ddShareImageWithImageData];
    
    if ([protocol respondsToSelector:@selector(ddShareImageWithUIImage)]) {
        [ext setImage:[protocol ddShareImageWithUIImage]];
    } else if ([protocol respondsToSelector:@selector(ddShareImageWithImageURL)]) {
        ext.imageUrl = [protocol ddShareImageWithImageURL];
    }else {
        ext.imageData = [UIImage imageData:imageData maxBytes:DDMiLiaoImageDataMaxSize];
    }
    
    MLMediaMessage* mediaMessage = [[MLMediaMessage alloc] init];
    mediaMessage.multiObject = ext;
    mediaMessage.title = [protocol ddShareImageWithTitle];
    mediaMessage.description = [protocol ddShareImageWithDescription];
    
    //缩略图
    NSData *thumbData = imageData;
    if ([protocol respondsToSelector:@selector(ddShareImageWithThumbnailData)]) {
        thumbData = [protocol ddShareImageWithThumbnailData];
    }
    mediaMessage.thumbData = [UIImage imageData:thumbData maxBytes:DDMiLiaoThumbnailDataMaxSize];
    return [self sendWithText:nil mediaMessage:mediaMessage];
}

- (BOOL)shareWebPageWithProtocol:(id<DDSocialShareWebPageProtocol>)protocol{
    
    MLMediaMessage *mediaMessage = [[MLMediaMessage alloc] init];
    mediaMessage.title = [protocol ddShareWebPageWithTitle];
    mediaMessage.description = [protocol ddShareWebPageWithDescription];
    
    //缩略图
    NSData *thumbData = [protocol ddShareWebPageWithImageData];
    mediaMessage.thumbData = [UIImage imageData:thumbData maxBytes:DDMiLiaoThumbnailDataMaxSize];
    
    MLAppExtendObject *ext = [MLAppExtendObject extendObject];
    ext.webUrl = [protocol ddShareWebPageWithWebpageUrl];
    mediaMessage.multiObject = ext;
    return [self sendWithText:nil mediaMessage:mediaMessage];
}

- (BOOL)sendWithText:(NSString *)text
        mediaMessage:(MLMediaMessage *)message{
    int scene = SceneType_Chat;
    if (self.shareScene == DDSSSceneMiLiaoSession) {
        scene = SceneType_Chat;
    } else if (self.shareScene == DDSSSceneMiLiaoTimeline){
        scene = SceneType_Wall;
    }
    MLMessageRequest *messageToMiLiaoReq = [[MLMessageRequest alloc] initWithUuid:nil targetMiliaoId:nil];
    messageToMiLiaoReq.text = text;
    messageToMiLiaoReq.bText = text ? YES : NO;
    messageToMiLiaoReq.message = message;
    messageToMiLiaoReq.scene = scene;
    return [MLAppApi sendRequest:messageToMiLiaoReq];
}

#pragma mark - MLAppApiDelgate

- (void)onResponse:(MLBaseResponse *)response {
    if ([response isKindOfClass:[MLBaseResponse class]]) {
        if (self.shareEventHandler) {
            if (response.errCode == MLAPP_ERR_CODE_OK) {
                self.shareEventHandler(DDSSPlatformMiLiao,self.shareScene,DDSSShareStateSuccess,nil);
            }
            else if (response.errCode == MLAPP_ERR_CODE_CANCEL){
                self.shareEventHandler(DDSSPlatformMiLiao,self.shareScene,DDSSShareStateCancel,nil);
            }
            else {
                NSError *error = [NSError errorWithDomain:@"MiLiao Share Error" code:response.errCode userInfo:@{NSLocalizedDescriptionKey:response.errDescription}];
                self.shareEventHandler(DDSSPlatformMiLiao,self.shareScene,DDSSShareStateFail,error);
            }
            self.shareEventHandler = nil;
        }
    }
}
@end

@implementation DDMiLiaoHandler (DDSocialHandlerProtocol)

+ (BOOL)isInstalled {
    return [MLAppApi isMLAppInstalled];
}

- (void)registerWithAppKey:(NSString *)appKey
                 appSecret:(NSString *)appSecret
               redirectURL:(NSString *)redirectURL
            appDescription:(NSString *)appDescription{
    [MLAppApi registerApp:[MLAppApi generateAppId:[[NSBundle mainBundle] bundleIdentifier]]];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [MLAppApi handOpenUrl:url withDelegate:self];
}

- (BOOL)shareWithController:(UIViewController *)viewController
                 shareScene:(DDSSScene)shareScene
                contentType:(DDSSContentType)contentType
                   protocol:(id<DDSocialShareContentProtocol>)protocol
                    handler:(DDSSShareEventHandler)handler {
    self.shareScene = shareScene;
    self.shareEventHandler = handler;
    if (self.shareEventHandler) {
        self.shareEventHandler(DDSSPlatformMiLiao, self.shareScene, DDSSShareStateBegan, nil);
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
            NSError *error = [NSError errorWithDomain:@"MiLiao Local Share Error" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
            self.shareEventHandler(DDSSPlatformMiLiao, self.shareScene, DDSSShareStateFail, error);
            self.shareEventHandler = nil;
        }
        return NO;
    }
}

- (BOOL)linkupWithItem:(DDLinkupItem *)linkupItem{
    return NO;
}
@end
