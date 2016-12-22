//
//  DDSystemTwitterHandler.m
//  DDSocialDemo
//
//  Created by dingdaojun on 16/1/4.
//  Copyright © 2016年 dingdaojun. All rights reserved.
//

#import "DDSystemTwitterHandler.h"
#import <Social/Social.h>

#import "DDSocialShareContentProtocol.h"
#import "DDSocialHandlerProtocol.h"
#import "DDAuthItem.h"

@interface DDSystemTwitterHandler ()

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, copy) DDSSShareEventHandler shareEventHandler;

@end

@implementation DDSystemTwitterHandler

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
    
    if (!composeViewController) {
        return NO;
    }
    
    composeViewController.completionHandler = ^(SLComposeViewControllerResult result) {
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

@implementation DDSystemTwitterHandler (DDSocialHandlerProtocol)

+ (BOOL)isInstalled {
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] && [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
}

- (BOOL)registerWithAppKey:(NSString *)appKey
                 appSecret:(NSString *)appSecret
               redirectURL:(NSString *)redirectURL
            appDescription:(NSString *)appDescription {
    return [DDSystemTwitterHandler isInstalled];
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
    } else if (contentType == DDSSContentTypeImage && [protocol conformsToProtocol:@protocol(DDSocialShareImageProtocol)]) {
        return [self shareImageWithProtocol:(id<DDSocialShareImageProtocol>)protocol];
    } else if (contentType == DDSSContentTypeWebPage && [protocol conformsToProtocol:@protocol(DDSocialShareWebPageProtocol)]) {
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
