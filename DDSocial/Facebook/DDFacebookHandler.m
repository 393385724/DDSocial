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
#import "DDSocialHandlerProtocol.h"
#import "DDAuthItem.h"
#import "DDUserInfoItem.h"

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
    photo.image = [UIImage imageWithImageData:[protocol ddShareImageWithImageData] maxBytes:DDFacebookImageDataMaxSize type:DDSocialImageTypeOrigin];
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    return [self sendWithContent:content];
}

- (BOOL)shareWebPageWithProtocol:(id<DDSocialShareWebPageProtocol>)protocol{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:[protocol ddShareWebPageWithWebpageUrl]];
    return [self sendWithContent:content];
}

- (BOOL)sendWithContent:(id<FBSDKSharingContent>)sharingContent{
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    //fix bug FBSDKShareDialog of Facebook SDK is not working on iOS9? http://www.basedb.net/Index/detail/id/537586.html
    if ([[self class] isInstalled]) {
        dialog.mode = FBSDKShareDialogModeNative;
    } else {
        dialog.mode = FBSDKShareDialogModeBrowser;
    }
    dialog.shareContent = sharingContent;
    dialog.delegate = self;
    dialog.fromViewController = self.viewController;
    [dialog show];
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

@implementation DDFacebookHandler (DDSocialHandlerProtocol)

+ (BOOL)isInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2:/"]];
}

//+ (BOOL)canShare {
//    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb-messenger-api:/"]];
//}

- (BOOL)registerWithAppKey:(NSString *)appKey
                 appSecret:(NSString *)appSecret
               redirectURL:(NSString *)redirectURL
            appDescription:(NSString *)appDescription {
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunchingNotification:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    return YES;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (BOOL)authWithMode:(DDSSAuthMode)mode
          controller:(UIViewController *)viewController
             handler:(DDSSAuthEventHandler)handler {
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
                                              if (result) {
                                                  if (result.isCancelled) {
                                                      if (handler) {
                                                          handler(DDSSPlatformFacebook, DDSSAuthStateCancel, nil, error);
                                                      }
                                                  } else {
                                                      if (handler) {
                                                          DDAuthItem *authItem = [DDAuthItem new];
                                                          authItem.thirdToken = result.token.tokenString;
                                                          authItem.thirdId = result.token.userID;
                                                          authItem.rawObject = result;
                                                          handler(DDSSPlatformFacebook, DDSSAuthStateSuccess, authItem, nil);
                                                      }
                                                  }
                                              } else {
                                                  if (handler) {
                                                      if (error.code == 1) {
                                                          //SFAuthenticationErrorCanceledLogin
                                                          handler(DDSSPlatformFacebook, DDSSAuthStateCancel, nil, error);
                                                      } else {
                                                          handler(DDSSPlatformFacebook, DDSSAuthStateFail, nil, error);
                                                      }
                                                  }
                                              }
                                          }];
    return YES;
}

- (BOOL)getUserInfoWithAuthItem:(DDAuthItem *)authItem
                        handler:(DDSSUserInfoEventHandler)handler{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me"
                                  parameters:@{@"fields":@"id,about,birthday,email,gender,name,picture"}];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (error) {
            handler(nil, error);
        } else {
            DDUserInfoItem *userInfoItem = [[DDUserInfoItem alloc] initWithPlatForm:DDSSPlatformFacebook rawObject:result];
            handler(userInfoItem,error);
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
    self.shareScene = shareScene;
    self.shareEventHandler = handler;
    
    if (self.shareEventHandler) {
        self.shareEventHandler(DDSSPlatformFacebook, self.shareScene, DDSSShareStateBegan, nil);
    }
    if (contentType == DDSSContentTypeText && [protocol conformsToProtocol:@protocol(DDSocialShareTextProtocol)]) {
        return [self shareTextWithProtocol:(id<DDSocialShareTextProtocol>)protocol];
    } else if (contentType == DDSSContentTypeImage && [protocol conformsToProtocol:@protocol(DDSocialShareImageProtocol)]) {
        return [self shareImageWithProtocol:(id<DDSocialShareImageProtocol>)protocol];
    } else if (contentType == DDSSContentTypeWebPage && [protocol conformsToProtocol:@protocol(DDSocialShareWebPageProtocol)]) {
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

@end
