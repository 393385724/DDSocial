//
//  DDSocialAuthHandler.m
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDSocialAuthHandler.h"
#import "DDSocialShareHandler.h"
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <GoogleSignIn/GIDGoogleUser.h>
#import <GoogleSignIn/GIDAuthentication.h>

@interface DDSocialAuthHandler ()

@end

@implementation DDSocialAuthHandler

+ (DDSocialAuthHandler *)sharedInstance{
    static DDSocialAuthHandler *_instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (BOOL)authWithPlatform:(DDSSPlatform)authPlatform
              controller:(UIViewController *)viewController
             authHandler:(DDSSAuthEventHandler)authHandler{
    if (!authHandler) {
        return NO;
    }
    DDSSAuthMode authMode = DDSSAuthModeToken;
    if (authPlatform == DDSSPlatformWeChat) {
        authMode = DDSSAuthModeCode;
    }
    return [[DDSocialShareHandler sharedInstance] authWithPlatform:authPlatform authMode:authMode controller:viewController handler:^(DDSSPlatform platform, DDSSAuthState state, DDAuthItem *authItem, NSError *error) {
        authHandler(authPlatform, state, authItem, error);
    }];
}

@end
