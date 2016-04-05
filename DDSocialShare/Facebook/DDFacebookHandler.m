//
//  DDFacebookHandler.m
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDFacebookHandler.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import "DDSocialShareContentProtocol.h"

#import "UIImage+Zoom.h"

const CGFloat DDFacebookImageDataMaxSize = 12 * 1024 * 1024;

@interface DDFacebookHandler ()<FBSDKSharingDelegate>

@property (nonatomic, strong) FBSDKLoginManager *fbLoginManager;

@property (nonatomic, assign) DDSSScene shareScene;
@property (nonatomic, copy) DDSSShareEventHandler shareEventHandler;
@property (nonatomic, weak) UIViewController *viewController;

@end

@implementation DDFacebookHandler

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (BOOL)isFacebookInstalled{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2:/"]];
}

+ (BOOL)isMessengerInstalled{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb-messenger-api:/"]];
}

- (void)registerApp{
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunchingNotification:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (BOOL)authWithMode:(DDSSAuthMode)mode
          controller:(UIViewController *)viewController
             handler:(DDSSAuthEventHandler)handler{
    if (handler) {
        handler(DDSSPlatformFacebook, DDSSAuthStateBegan, nil, nil);
    }
    NSArray *permissions = @[@"email",
                             @"user_friends",
                             @"public_profile"];
    if (self.fbLoginManager) {
        //try fix bug com.facebook.sdk.login code = 308 使用相同的fbsdkloginmanager实例直到登出，然后创建一个新的实例
        [self.fbLoginManager logOut];
    }
    self.fbLoginManager = [[FBSDKLoginManager alloc] init];
    [self.fbLoginManager logInWithReadPermissions:permissions
                               fromViewController:viewController
                                          handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                           if (error) {
                                               if (handler) {
                                                   handler(DDSSPlatformFacebook, DDSSAuthStateFail, nil, error);
                                               }
                                           } else if (result.isCancelled){
                                               if (handler) {
                                                   handler(DDSSPlatformFacebook, DDSSAuthStateFail, nil, error);
                                               }
                                           } else {
                                               if (handler) {
                                                   handler(DDSSPlatformFacebook, DDSSAuthStateSuccess, result.token, nil);
                                               }
                                           }
                                          }];
    return YES;
}

- (BOOL)shareWithViewController:(UIViewController *)viewController
                       protocol:(id<DDSocialShareContentProtocol>)protocol
                     shareScene:(DDSSScene)shareScene
                    contentType:(DDSSContentType)contentType
                        handler:(DDSSShareEventHandler)handler{
    self.viewController = viewController;
    self.shareScene = shareScene;
    self.shareEventHandler = handler;
    
    if (self.shareEventHandler) {
        self.shareEventHandler(DDSSPlatformFacebook, self.shareScene, DDSSShareStateBegan, nil);
    }
    if (contentType == DDSSContentTypeText && [protocol conformsToProtocol:@protocol(DDSocialShareTextProtocol)]) {
        return [self shareTextWithProtocol:(id<DDSocialShareTextProtocol>)protocol];
    } else if (contentType == DDSSContentTypeImage && [protocol conformsToProtocol:@protocol(DDSocialShareImageProtocol)]){
        return [self shareImageWithProtocol:(id<DDSocialShareImageProtocol>)protocol];
    } else if (contentType == DDSSContentTypeWebPage && [protocol conformsToProtocol:@protocol(DDSocialShareWebPageProtocol)]){
        return [self shareWebPageWithProtocol:(id<DDSocialShareWebPageProtocol>)protocol];
    } else {
        if (self.shareEventHandler) {
            NSString *errorDescription = [NSString stringWithFormat:@"分享格式错误:%@ shareType:%lu",NSStringFromClass([protocol class]),(unsigned long)contentType];
            NSError *error = [NSError errorWithDomain:@"Facebook Share Error" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
            self.shareEventHandler(DDSSPlatformFacebook, self.shareScene, DDSSShareStateFail, error);
            self.shareEventHandler = nil;
        }
        return NO;
    }
}

#pragma mark - Private Methods

- (BOOL)shareTextWithProtocol:(id<DDSocialShareTextProtocol>)protocol{
    if (self.shareEventHandler) {
        NSError *error = [NSError errorWithDomain:@"不支持的分享类型" code:-1 userInfo:nil];
        self.shareEventHandler(DDSSPlatformFacebook, self.shareScene, DDSSShareStateFail, error);
        self.shareEventHandler = nil;
    }
    return NO;
}

- (BOOL)shareImageWithProtocol:(id<DDSocialShareImageProtocol>)protocol{
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = [UIImage imageWithImageData:[protocol ddShareImageWithImageData] maxBytes:DDFacebookImageDataMaxSize];
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    return [self sendWithContent:content];
}

- (BOOL)shareWebPageWithProtocol:(id<DDSocialShareWebPageProtocol>)protocol{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:[protocol ddShareWebPageWithWebpageUrl]];
    content.contentTitle = [protocol ddShareWebPageWithTitle];
    content.contentDescription = [protocol ddShareWebPageWithDescription];
    if ([protocol respondsToSelector:@selector(ddShareWebPageWithThumbnailURL)]) {
        content.imageURL = [NSURL URLWithString:[protocol ddShareWebPageWithThumbnailURL]];
    }
    return [self sendWithContent:content];
}

- (BOOL)sendWithContent:(id<FBSDKSharingContent>)sharingContent{
    if (self.shareScene == DDSSSceneFBSession) {
        [FBSDKMessageDialog showWithContent:sharingContent delegate:self];
    } else {
        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
        //fix bug FBSDKShareDialog of Facebook SDK is not working on iOS9? http://www.basedb.net/Index/detail/id/537586.html
        if ([[self class] isFacebookInstalled]){
            dialog.mode = FBSDKShareDialogModeNative;
        } else {
            dialog.mode = FBSDKShareDialogModeBrowser;
        }
        dialog.shareContent = sharingContent;
        dialog.delegate = self;
        dialog.fromViewController = self.viewController;
        [dialog show];
    }
    return YES;
}


#pragma mark - FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    if ([[results allKeys] count] == 0) {
        if (self.shareEventHandler) {
            self.shareEventHandler(DDSSPlatformFacebook, self.shareScene, DDSSShareStateCancel, nil);
        }
    } else {
        if (self.shareEventHandler) {
            self.shareEventHandler(DDSSPlatformFacebook, self.shareScene, DDSSShareStateSuccess, nil);
        }
    }
    self.shareEventHandler = nil;
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    if (self.shareEventHandler) {
        self.shareEventHandler(DDSSPlatformFacebook, self.shareScene, DDSSShareStateFail, error);
        self.shareEventHandler = nil;
    }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    if (self.shareEventHandler) {
        self.shareEventHandler(DDSSPlatformFacebook, self.shareScene, DDSSShareStateCancel, nil);
        self.shareEventHandler = nil;
    }
}

#pragma mark - Notification

- (void)applicationDidFinishLaunchingNotification:(NSNotification *)notification{
    [[FBSDKApplicationDelegate sharedInstance] application:notification.object
                             didFinishLaunchingWithOptions:notification.userInfo];
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification{
    [FBSDKAppEvents activateApp];
}

@end
