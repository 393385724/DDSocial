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

#import "DDMIHandler.h"

@interface DDSocialAuthHandler ()

@property (nonatomic, strong) DDMIHandler *miHandler;

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

- (void)registerMIApp:(NSString *)appid
          redirectURL:(NSString *)redirectURL{
    [self.miHandler registerApp:appid withRedirectURL:redirectURL];
}

- (BOOL)authWithPlatform:(DDSSPlatform)authPlatform
              controller:(UIViewController *)viewController
             authHandler:(DDSSAuthEventHandler)authHandler{
    if (!authHandler) {
        return NO;
    }
    if (authPlatform == DDSSPlatformMI) {
        return [self.miHandler authWithType:DDMIAuthResponseTypeCode controller:viewController handler:^(DDMIAuthState state, NSDictionary *response, NSError *error) {
            switch (state) {
                case DDMIAuthStateBegan: {
                    authHandler(authPlatform, DDSSAuthStateBegan, nil, nil);
                    break;
                }
                case DDMIAuthStateSuccess: {
                    DDAuthItem *authItem = [[DDAuthItem alloc] init];
                    authItem.thirdToken = [response objectForKey:@"code"];
                    authHandler(authPlatform, DDSSAuthStateSuccess, authItem, nil);
                    break;
                }
                case DDMIAuthStateFail: {
                    authHandler(authPlatform, DDSSAuthStateFail, nil, error);
                    break;
                }
                case DDMIAuthStateCancel: {
                    authHandler(authPlatform, DDSSAuthStateCancel, nil, nil);
                    break;
                }
                default: {
                    break;
                }
            }
        }];
    } else {
        DDSSAuthMode authMode = DDSSAuthModeToken;
        if (authPlatform == DDSSPlatformWeChat) {
            authMode = DDSSAuthModeCode;
        }
        return [[DDSocialShareHandler sharedInstance] authWithPlatform:authPlatform authMode:authMode controller:viewController handler:^(DDSSPlatform platform, DDSSAuthState state, id result, NSError *error) {
            DDAuthItem *authItem = nil;
            if (state == DDSSAuthStateSuccess) {
                authItem = [self authItemWithResult:result platform:platform];
            }
            authHandler(authPlatform, state, authItem, error);
        }];
    }
}

#pragma mark - Private Methods

- (DDAuthItem *)authItemWithResult:(id)result platform:(DDSSPlatform)platform{
    DDAuthItem *authItem = [[DDAuthItem alloc] init];
    switch (platform) {
        case DDSSPlatformWeChat: {
            authItem.thirdToken = result;
            break;
        }
        case DDSSPlatformQQ: {
            
            break;
        }
        case DDSSPlatformSina: {
            
            break;
        }
        case DDSSPlatformFacebook: {
            FBSDKAccessToken *token = (FBSDKAccessToken *)result;
            authItem.thirdToken = token.tokenString;
            authItem.thirdId = token.userID;
            authItem.isCodeAuth = NO;
            break;
        }
        case DDSSPlatformTwitter: {
            
            break;
        }
        case DDSSPlatformGoogle:{
            GIDGoogleUser *googleUser = (GIDGoogleUser *)result;
            authItem.thirdToken = googleUser.authentication.accessToken;
            authItem.isCodeAuth = NO;
            authItem.thirdId = googleUser.userID;
            break;
        }
        default: {
            break;
        }
    }
    
    return authItem;
}

#pragma mark - Getter and Setter

- (DDMIHandler *)miHandler{
    if (!_miHandler) {
        _miHandler = [[DDMIHandler alloc] init];
    }
    return _miHandler;
}


@end
