//
//  DDGoogleHandler.m
//  DDSocialDemo
//
//  Created by lilingang on 16/4/11.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDGoogleHandler.h"
#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GoogleSignIn/GIDSignIn.h>

#import "DDSocialHandlerProtocol.h"
#import "DDAuthItem.h"

@interface DDGoogleHandler ()<GIDSignInDelegate, GIDSignInUIDelegate>

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, copy) DDSSAuthEventHandler authEventHandler;

@end

@implementation DDGoogleHandler

#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (self.authEventHandler) {
        if (error) {
            if (error.code == kGIDSignInErrorCodeCanceled) {
                self.authEventHandler(DDSSPlatformGoogle, DDSSAuthStateCancel, nil, nil);
            } else {
                self.authEventHandler(DDSSPlatformGoogle, DDSSAuthStateFail, nil, error);
            }
        } else {
            DDAuthItem *authItem = [DDAuthItem new];
            authItem.thirdId = user.userID;
            authItem.thirdToken = user.authentication.accessToken;
            authItem.rawObject = user;
            self.authEventHandler(DDSSPlatformGoogle, DDSSAuthStateSuccess, authItem, nil);
        }
    }
    self.authEventHandler = nil;
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (self.authEventHandler) {
        self.authEventHandler(DDSSPlatformGoogle, DDSSAuthStateFail, nil, error);
        self.authEventHandler = nil;
    }
}

#pragma mark - GIDSignInUIDelegate

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error{
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController{
    [self.viewController presentViewController:viewController animated:YES completion:^{
        
    }];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController{
    [self.viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end

@implementation DDGoogleHandler (DDSocialHandlerProtocol)

// MARK: TODO
+ (BOOL)isInstalled {
    return NO;
}

// MARK: TODO
+ (BOOL)canShare {
    return NO;
}

- (BOOL)registerWithAppKey:(NSString *)appKey
                 appSecret:(NSString *)appSecret
               redirectURL:(NSString *)redirectURL
            appDescription:(NSString *)appDescription {
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    if (configureError) {
        return NO;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}

- (BOOL)authWithMode:(DDSSAuthMode)mode
          controller:(UIViewController *)viewController
             handler:(DDSSAuthEventHandler)handler {
    if (!handler) {
        return NO;
    }
    self.viewController = viewController;
    self.authEventHandler = handler;
    self.authEventHandler(DDSSPlatformGoogle, DDSSAuthStateBegan, nil, nil);
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signIn];
    return YES;
}

// MARK: TODO
- (BOOL)shareWithController:(UIViewController *)viewController
                 shareScene:(DDSSScene)shareScene
                contentType:(DDSSContentType)contentType
                   protocol:(id<DDSocialShareContentProtocol>)protocol
                    handler:(DDSSShareEventHandler)handler {
    return NO;
}

- (BOOL)linkupWithItem:(DDLinkupItem *)linkupItem{
    return NO;
}

@end
