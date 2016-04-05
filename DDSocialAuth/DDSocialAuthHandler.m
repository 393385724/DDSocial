//
//  DDSocialAuthHandler.m
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDSocialAuthHandler.h"
#import <FBSDKCoreKit/FBSDKAccessToken.h>

#import "DDMIHandler.h"
#import "DDSocialShareHandler.h"

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

- (void)registerPlatform:(DDAuthPlatform)platform
             redirectURL:(NSString *)redirectURL{
    if (platform == DDAuthPlatformMI) {
        [self.miHandler registerAppWithRedirectURL:redirectURL];
    }
}

- (BOOL)authWithPlatform:(DDAuthPlatform)authPlatform
                    mode:(DDAuthMode)mode
              controller:(UIViewController *)viewController
             authHandler:(DDAuthEventHandler)authHandler{
    if (!authHandler) {
        return NO;
    }
    if (authPlatform == DDAuthPlatformMI) {
        DDMIAuthResponseType responseType = DDMIAuthResponseTypeCode;
        if (mode == DDAuthModeToken) {
            responseType = DDMIAuthResponseTypeToken;
        }
        return [self.miHandler authWithType:responseType controller:viewController handler:^(DDMIAuthState state, NSDictionary *response, NSError *error) {
            switch (state) {
                case DDMIAuthStateBegan: {
                    authHandler(authPlatform, DDAuthStateBegan, nil, nil);
                    break;
                }
                case DDMIAuthStateSuccess: {
                    __block DDAuthItem *authItem = [[DDAuthItem alloc] init];
                    if (responseType == DDMIAuthResponseTypeCode) {
                        authItem.thirdToken = [response objectForKey:@"code"];
                        authHandler(authPlatform, DDAuthStateSuccess, authItem, nil);
                    } else {
                        authItem.thirdToken = [response objectForKey:@"access_token"];
                        authItem.thirdTokenId = [response objectForKey:@"mac_key"];
                        [self.miHandler getProfileInfoWithAccessToken:authItem.thirdToken handler:^(DDMIUserInfoItem *userInfoItem, NSError *error) {
                            if (error) {
                                authHandler(authPlatform, DDAuthStateFail, nil, error);
                            } else {
                                authItem.thirdId = userInfoItem.userId;
                                authHandler(authPlatform, DDAuthStateSuccess, authItem, nil);
                            }
                        }];
                    }
                    break;
                }
                case DDMIAuthStateFail: {
                    authHandler(authPlatform, DDAuthStateFail, nil, error);
                    break;
                }
                case DDMIAuthStateCancel: {
                    authHandler(authPlatform, DDAuthStateCancel, nil, nil);
                    break;
                }
                default: {
                    break;
                }
            }
        }];
    } else {
        DDSSAuthMode ssAuthMode = [self ssModeWithAuthMode:mode];
        DDSSPlatform  ssPlatform = [self socialPlatformWithAuthPlatform:authPlatform];
        return [[DDSocialShareHandler sharedInstance] authWithPlatform:ssPlatform authMode:ssAuthMode controller:viewController handler:^(DDSSPlatform platform, DDSSAuthState state, id result, NSError *error) {
            switch (state) {
                case DDSSAuthStateBegan: {
                    authHandler(authPlatform, DDAuthStateBegan, nil, error);
                    break;
                }
                case DDSSAuthStateSuccess: {
                    DDAuthItem *authItem = [self authItemWithResult:result platform:platform authMode:ssAuthMode];
                    authHandler(authPlatform, DDAuthStateSuccess, authItem, nil);
                    break;
                }
                case DDSSAuthStateFail: {
                    authHandler(authPlatform, DDAuthStateFail, nil, error);
                    break;
                }
                case DDSSAuthStateCancel: {
                    authHandler(authPlatform, DDAuthStateCancel, nil, nil);
                    break;
                }
                default: {
                    break;
                }
            }
        }];
    }
}

#pragma mark - Private Methods

- (DDSSAuthMode)ssModeWithAuthMode:(DDAuthMode)mode{
    switch (mode) {
        case DDAuthModeCode: {
            return DDSSAuthModeCode;
            break;
        }
        case DDAuthModeToken: {
            return DDSSAuthModeToken;
            break;
        }
        default: {
            return DDSSAuthModeCode;
            break;
        }
    }
}

- (DDSSPlatform)socialPlatformWithAuthPlatform:(DDAuthPlatform)authPlatform{
    switch (authPlatform) {
        case DDAuthPlatformNone: {
            return DDSSPlatformNone;
            break;
        }
        case DDAuthPlatformWeChat: {
            return DDSSPlatformWeChat;
            break;
        }
        case DDAuthPlatformQQ: {
            return DDSSPlatformQQ;
            break;
        }
        case DDAuthPlatformSina: {
            return DDSSPlatformSina;
            break;
        }
        case DDAuthPlatformFacebook: {
            return DDSSPlatformFacebook;
            break;
        }
        case DDAuthPlatformTwitter: {
            return DDSSPlatformTwitter;
            break;
        }
        case DDAuthPlatformMI: {
            return DDSSPlatformNone;
            break;
        }
        default: {
            return DDSSPlatformNone;
            break;
        }
    }
}

- (DDAuthItem *)authItemWithResult:(id)result platform:(DDSSPlatform)platform authMode:(DDSSAuthMode)mode{
    DDAuthItem *authItem = [[DDAuthItem alloc] init];
    switch (platform) {
        case DDSSPlatformWeChat: {
            if (mode == DDSSAuthModeCode) {
                authItem.thirdToken = result;
            } else {
                
            }
            break;
        }
        case DDSSPlatformQQ: {
            
            break;
        }
        case DDSSPlatformSina: {
            
            break;
        }
        case DDSSPlatformFacebook: {
            if (mode == DDSSAuthModeCode) {
                
            } else {
                FBSDKAccessToken *token = (FBSDKAccessToken *)result;
                authItem.thirdToken = token.tokenString;
                authItem.thirdId = token.userID;
            }
            break;
        }
        case DDSSPlatformTwitter: {
            
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
