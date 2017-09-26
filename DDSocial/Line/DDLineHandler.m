//
//  DDLineHandler.m
//  DDSocialCodeDemo
//
//  Created by 李林刚 on 2017/9/26.
//  Copyright © 2017年 LiLingang. All rights reserved.
//
//http://www.jianshu.com/p/1ef72f37919c
//line 的分享主要是按照如下方式进行的：line://msg/<CONTENT TYPE>/<CONTENT KEY>
//1、分享文字<CONTENT TYPE> 的值为 text ,
//2、分享图片<CONTENT TYPE> 的值为 image
//<CONTENT TYPE> 的值需要进行 UTF-8 编码.

#import "DDLineHandler.h"
#import <LineSDK/LineSDK.h>

#import "DDAuthItem.h"
#import "DDSocialShareContentProtocol.h"

@interface DDLineHandler ()<LineSDKLoginDelegate, DDSocialShareContentProtocol>

/*授权*/
@property (nonatomic, copy) DDSSAuthEventHandler authEventHandler;

/*分享*/
@property (nonatomic, assign) DDSSScene shareScene;
@property (nonatomic, copy) DDSSShareEventHandler shareEventHandler;

@end

@implementation DDLineHandler

#pragma mark - DDSocialShareContentProtocol

- (BOOL)shareTextWithProtocol:(id<DDSocialShareTextProtocol>)protocol{
    NSString *text = [protocol ddShareText];
    if (!text) {
        if (self.shareEventHandler) {
            NSError *error = [NSError errorWithDomain:@"DDSocialShare Domain" code:404 userInfo:@{NSLocalizedDescriptionKey:@"text is nil"}];
            self.shareEventHandler(DDSSPlatformLine, self.shareScene, DDSSShareStateFail, error);
            self.shareEventHandler = nil;
        }
        return NO;
    }
    NSString *contentType = @"text";
    NSString *contentKey = text;
    return [self openURLWithContentType:contentType contentKey:contentKey];
}

- (BOOL)shareImageWithProtocol:(id<DDSocialShareImageProtocol>)protocol{
    NSData *imageData = [protocol ddShareImageWithImageData];
    if (!imageData) {
        if (self.shareEventHandler) {
            NSError *error = [NSError errorWithDomain:@"DDSocialShare Domain" code:404 userInfo:@{NSLocalizedDescriptionKey:@"image is nil"}];
            self.shareEventHandler(DDSSPlatformLine, self.shareScene, DDSSShareStateFail, error);
            self.shareEventHandler = nil;
        }
        return NO;
    }
    UIImage *image = [UIImage imageWithData:imageData];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setData:UIImageJPEGRepresentation(image, 0.9) forPasteboardType:@"public.jpeg"];
    NSString *contentType =@"image";
    NSString *contentKey = pasteboard.name;
    return [self openURLWithContentType:contentType contentKey:contentKey];
}

- (BOOL)openURLWithContentType:(NSString *)contentType contentKey:(NSString *)contentKey {
    if ([[self class] isInstalled]) {
        contentKey = [contentKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *urlString = [NSString stringWithFormat:@"line://msg/%@/%@",contentType, contentKey];
        return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }else{
        return NO;
    }
}

#pragma mark - LineSDKLoginDelegate

- (void)didLogin:(LineSDKLogin *)login
      credential:(LineSDKCredential *)credential
         profile:(LineSDKProfile *)profile
           error:(NSError *)error{
    if (error) {
        if (error.code == 3) {
            if (self.authEventHandler) {
                self.authEventHandler(DDSSPlatformLine, DDSSAuthStateCancel, nil, nil);
            }
        } else {
            if (self.authEventHandler) {
                self.authEventHandler(DDSSPlatformLine, DDSSAuthStateFail, nil, error);
            }
        }
    } else {
        if (self.authEventHandler) {
            DDAuthItem *authItem = [DDAuthItem new];
            authItem.thirdToken = credential.accessToken.accessToken;
            authItem.thirdId = profile.userID;
            authItem.rawObject = credential;
            authItem.rawProfileObject = profile;
            self.authEventHandler(DDSSPlatformLine,DDSSAuthStateSuccess, authItem, nil);
        }
    }
    self.authEventHandler = nil;
}


@end


@implementation DDLineHandler (DDSocialHandlerProtocol)

+ (BOOL)isInstalled {
    return[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"line://"]];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[LineSDKLogin sharedInstance] handleOpenURL:url];
}

- (BOOL)authWithMode:(DDSSAuthMode)mode
          controller:(UIViewController *)viewController
             handler:(DDSSAuthEventHandler)handler {
    self.authEventHandler = handler;
    
    if (self.authEventHandler) {
        self.authEventHandler(DDSSPlatformLine,DDSSAuthStateBegan, nil, nil);
    }
    
    [LineSDKLogin sharedInstance].delegate = self;
    if ([[self class] isInstalled]) {
        [[LineSDKLogin sharedInstance] startLogin];
    } else {
        [[LineSDKLogin sharedInstance] startWebLoginWithSafariViewController:YES];
    }

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
    self.shareScene = shareScene;
    self.shareEventHandler = handler;
    if (self.shareEventHandler) {
        self.shareEventHandler(DDSSPlatformLine, self.shareScene, DDSSShareStateBegan, nil);
    }
    BOOL openSuccess = NO;
    if (contentType == DDSSContentTypeText && [protocol conformsToProtocol:@protocol(DDSocialShareTextProtocol)]) {
        openSuccess = [self shareTextWithProtocol:(id<DDSocialShareTextProtocol>)protocol];
    } else if (contentType == DDSSContentTypeImage && [protocol conformsToProtocol:@protocol(DDSocialShareImageProtocol)]) {
        openSuccess = [self shareImageWithProtocol:(id<DDSocialShareImageProtocol>)protocol];
    } else {
        if (self.shareEventHandler) {
            NSString *errorDescription = [NSString stringWithFormat:@"share format error:%@ shareType:%lu",NSStringFromClass([protocol class]),(unsigned long)contentType];
            NSError *error = [NSError errorWithDomain:@"Line Local Share Error" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
            self.shareEventHandler(DDSSPlatformLine, self.shareScene, DDSSShareStateFail, error);
            self.shareEventHandler = nil;
        }
        return NO;
    }
    if (openSuccess) {
        if (self.shareEventHandler) {
            self.shareEventHandler(DDSSPlatformLine, self.shareScene, DDSSShareStateSuccess, nil);
        }
    }
    return openSuccess;
}

@end
