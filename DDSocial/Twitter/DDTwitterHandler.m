//
//  DDTwitterHandler.m
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDTwitterHandler.h"
#import <Social/Social.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>

#import "DDSocialShareContentProtocol.h"
#import "DDSocialHandlerProtocol.h"
#import "DDAuthItem.h"

@interface DDTwitterHandler ()

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, copy) DDSSShareEventHandler shareEventHandler;

@end

@implementation DDTwitterHandler

#pragma mark - Private Methods

- (BOOL)shareTextWithProtocol:(id<DDSocialShareTextProtocol>)protocol{
    SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [composeViewController setInitialText:[protocol ddShareText]];
    return [self sendInComposeViewController:composeViewController];
}

- (BOOL)shareImageWithProtocol:(id<DDSocialShareImageProtocol>)protocol{
    SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    if ([protocol respondsToSelector:@selector(ddShareImageText)]) {
        [composeViewController setInitialText:[protocol ddShareImageText]];
    }
    
    UIImage *image;
    if ([protocol respondsToSelector:@selector(ddShareImageWithUIImage)]) {
        image = [protocol ddShareImageWithUIImage];
    } else {
        image = [UIImage imageWithData:[protocol ddShareImageWithImageData]];
    }
    [composeViewController addImage:image];
    
    return [self sendInComposeViewController:composeViewController];
}

- (BOOL)shareWebPageWithProtocol:(id<DDSocialShareWebPageProtocol>)protocol{
    SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    if ([protocol respondsToSelector:@selector(ddShareWebPageText)]) {
        [composeViewController setInitialText:[protocol ddShareWebPageText]];
    }
    
    UIImage *image = [UIImage imageWithData:[protocol ddShareWebPageWithImageData]];
    [composeViewController addImage:image];
    [composeViewController addURL:[NSURL URLWithString:[protocol ddShareWebPageWithWebpageUrl]]];
    
    return [self sendInComposeViewController:composeViewController];
}

- (BOOL)sendInComposeViewController:(SLComposeViewController *)composeViewController {
    composeViewController.completionHandler = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            if (self.shareEventHandler) {
                self.shareEventHandler(DDSSPlatformTwitter, DDSSSceneTwitter, DDSSShareStateCancel, nil);
                self.shareEventHandler = nil;
            }
        } else {
            if (self.shareEventHandler) {
                self.shareEventHandler(DDSSPlatformTwitter, DDSSSceneTwitter, DDSSShareStateSuccess, nil);
                self.shareEventHandler = nil;
            }
        }
    };
    [self.viewController presentViewController:composeViewController animated:YES completion:nil];
    return YES;
}

@end

@implementation DDTwitterHandler (DDSocialHandlerProtocol)

+ (BOOL)isInstalled {
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] && [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
}

- (BOOL)registerWithAppKey:(NSString *)appKey
                 appSecret:(NSString *)appSecret
               redirectURL:(NSString *)redirectURL
            appDescription:(NSString *)appDescription {
    if (appKey && [appKey length] > 0 && appSecret && [appSecret length] > 0) {
        [[Twitter sharedInstance] startWithConsumerKey:appKey consumerSecret:appSecret];
    }
    [Fabric with:@[[Twitter class]]];
    return YES;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return NO;
}

- (BOOL)authWithMode:(DDSSAuthMode)mode
          controller:(UIViewController *)viewController
             handler:(DDSSAuthEventHandler)handler {
    if (handler) {
        handler(DDSSPlatformTwitter, DDSSAuthStateBegan, nil, nil);
    }
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        if (error) {
            if (handler) {
                handler(DDSSPlatformTwitter, DDSSAuthStateFail, nil, error);
            }
        } else {
            if (handler) {
                DDAuthItem *authItem = [DDAuthItem new];
                authItem.thirdToken = session.authToken;
                authItem.thirdId = session.userID;
                authItem.rawObject = session;
                handler(DDSSPlatformTwitter, DDSSAuthStateSuccess, authItem, nil);
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
    self.viewController = viewController;
    self.shareEventHandler = handler;
    
    if (self.shareEventHandler) {
        self.shareEventHandler(DDSSPlatformTwitter,DDSSSceneTwitter,DDSSShareStateBegan,nil);
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
            NSError *error = [NSError errorWithDomain:@"Twitter Local Share Error" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
            self.shareEventHandler(DDSSPlatformTwitter, DDSSSceneTwitter, DDSSShareStateFail, error);
            self.shareEventHandler = nil;
        }
        return NO;
    }
}

@end
