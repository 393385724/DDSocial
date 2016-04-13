//
//  DDSocialShareHandler.m
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDSocialShareHandler.h"
#import <UIKit/UIKit.h>

#import "DDWeChatHandler.h"
#import "DDSinaHandler.h"
#import "DDTencentHandler.h"
#import "DDFacebookHandler.h"
#import "DDGoogleHandler.h"
#import "DDTwitterHandler.h"
#import "DDMiLiaoHandler.h"

@interface DDSocialShareHandler ()

@property (nonatomic, strong) DDWeChatHandler   *wechatHandler;
@property (nonatomic, strong) DDSinaHandler     *sinaHandler;
@property (nonatomic, strong) DDTencentHandler  *tencentHandler;
@property (nonatomic, strong) DDFacebookHandler *facebookHandler;
@property (nonatomic, strong) DDGoogleHandler   *googleHandler;
@property (nonatomic, strong) DDTwitterHandler  *twitterHandler;
@property (nonatomic, strong) DDMiLiaoHandler   *miliaoHandler;

@end

@implementation DDSocialShareHandler

+ (DDSocialShareHandler *)sharedInstance{
    static DDSocialShareHandler *_instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - Public Methods

+ (BOOL)isInstalledPlatform:(DDSSPlatform)platform{
    if (platform == DDSSPlatformWeChat) {
        return [DDWeChatHandler isWeChatInstalled];
    } else if (platform == DDSSPlatformSina){
        return [DDSinaHandler isSinaInstalled];
    } else if (platform == DDSSPlatformQQ){
        return [DDTencentHandler isQQInstalled];
    } else if (platform == DDSSPlatformFacebook){
        return [DDFacebookHandler isFacebookInstalled];
    } else if (platform == DDSSPlatformTwitter){
        return [DDTwitterHandler isTwitterInstalled];
    } else if (platform == DDSSPlatformMiLiao){
        return [DDMiLiaoHandler isMiLiaoInstalled];
    }
    return YES;
}

+ (BOOL)canShareToScence:(DDSSScene)scene{
    if (scene == DDSSSceneQQFrined || scene == DDSSSceneQZone) {
        return [self isInstalledPlatform:DDSSPlatformQQ];
    } else if (scene == DDSSSceneWXSession || scene == DDSSSceneWXTimeline){
        return [self isInstalledPlatform:DDSSPlatformWeChat];
    } else if (scene == DDSSSceneSina){
        return [self isInstalledPlatform:DDSSPlatformSina];
    } else if (scene == DDSSSceneFBSession){
        return [DDFacebookHandler isMessengerInstalled];
    } else if (scene == DDSSSceneFBTimeline){
        return [self isInstalledPlatform:DDSSPlatformFacebook];
    } else if (scene == DDSSSceneTwitter){
        return [self isInstalledPlatform:DDSSPlatformTwitter];
    } else if (scene == DDSSSceneMiLiaoSession || scene == DDSSSceneMiLiaoTimeline){
        return [self isInstalledPlatform:DDSSPlatformMiLiao];
    } else {
        return NO;
    }
}

- (void)registerPlatform:(DDSSPlatform)platform
                  appKey:(NSString *)appKey{
    [self registerPlatform:platform appKey:appKey appSecret:@"" redirectURL:@"" appDescription:@""];
}

- (void)registerPlatform:(DDSSPlatform)platform
                  appKey:(NSString *)appKey
             redirectURL:(NSString *)redirectURL{
    [self registerPlatform:platform appKey:appKey appSecret:@"" redirectURL:redirectURL appDescription:@""];
}

- (void)registerPlatform:(DDSSPlatform)platform
                  appKey:(NSString *)appKey
               appSecret:(NSString *)appSecret
             redirectURL:(NSString *)redirectURL
          appDescription:(NSString *)appDescription{
    if (platform == DDSSPlatformWeChat) {
        [self.wechatHandler registerApp:appKey withDescription:appDescription];
    } else if (platform == DDSSPlatformSina){
        [self.sinaHandler registerApp:appKey withRedirectURI:redirectURL];
    } else if (platform == DDSSPlatformQQ){
        [self.tencentHandler registerApp:appKey];
    } else if (platform == DDSSPlatformFacebook){
        [self.facebookHandler registerApp];
    } else if (platform == DDSSPlatformGoogle){
        [self.googleHandler registerApp];
    } else if (platform == DDSSPlatformTwitter){

    } else if (platform == DDSSPlatformMiLiao){
        [self.miliaoHandler registerApp];
    }
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    BOOL canWeChatOpen = [self.wechatHandler handleOpenURL:url];
    if (canWeChatOpen) {
        return YES;
    }
    BOOL canSinaOpen = [self.sinaHandler handleOpenURL:url];
    if (canSinaOpen) {
        return YES;
    }
    BOOL canQQOpen = [self.tencentHandler handleOpenURL:url];
    if (canQQOpen) {
        return YES;
    }
    BOOL canFacebookOpen = [self.facebookHandler application:application handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (canFacebookOpen) {
        return YES;
    }
    BOOL canGooleOpen = [self.googleHandler application:application handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (canGooleOpen) {
        return YES;
    }
    
    BOOL canMiliaoOpen = [self.miliaoHandler handleOpenURL:url];
    if (canMiliaoOpen) {
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options{
    NSString *sourceApplicationKey = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    id annotationApplicationKey = options[UIApplicationOpenURLOptionsAnnotationKey];
    return [self application:app handleOpenURL:url sourceApplication:sourceApplicationKey annotation:annotationApplicationKey];
}


- (BOOL)authWithPlatform:(DDSSPlatform)platform
                authMode:(DDSSAuthMode)authMode
              controller:(UIViewController *)viewController
                 handler:(DDSSAuthEventHandler)handler{
    if (platform == DDSSPlatformWeChat) {
        return [self.wechatHandler authWithMode:authMode controller:viewController handler:handler];
    } else if (platform == DDSSPlatformSina){
        return [self.sinaHandler authWithMode:authMode handler:handler];
    } else if (platform == DDSSPlatformQQ){
        return [self.tencentHandler authWithMode:authMode handler:handler];
    } else if (platform == DDSSPlatformFacebook){
        return [self.facebookHandler authWithMode:authMode controller:viewController handler:handler];
    } else if (platform == DDSSPlatformGoogle){
        return [self.googleHandler authWithViewController:viewController handler:handler];
    }
    return YES;
}


- (BOOL)shareWithPlatform:(DDSSPlatform)platform
               controller:(UIViewController *)viewController
               shareScene:(DDSSScene)shareScene
              contentType:(DDSSContentType)contentType
                 protocol:(id<DDSocialShareContentProtocol>)protocol
                  handler:(DDSSShareEventHandler)handler{
    if (![self respondsToSelectorWithProtocol:protocol type:contentType] || !handler) {
        return NO;
    }
    if (platform == DDSSPlatformWeChat) {
       return [self.wechatHandler shareWithProtocol:protocol shareScene:shareScene contentType:contentType handler:handler];
    } else if (platform == DDSSPlatformSina){
        return [self.sinaHandler shareWithProtocol:protocol contentType:contentType handler:handler];
    } else if (platform == DDSSPlatformQQ){
        return [self.tencentHandler shareWithProtocol:protocol shareScene:shareScene contentType:contentType handler:handler];
    } else if (platform == DDSSPlatformFacebook){
        return [self.facebookHandler shareWithViewController:viewController protocol:protocol shareScene:shareScene contentType:contentType handler:handler];
    } else if (platform == DDSSPlatformTwitter){
        return [self.twitterHandler shareWithViewController:viewController protocol:protocol contentType:contentType handler:handler];
    } else if (platform == DDSSPlatformMiLiao){
        return [self.miliaoHandler shareWithProtocol:protocol shareScene:shareScene contentType:contentType handler:handler];
    }
    return YES;
}

- (BOOL)linkupWithPlatform:(DDSSPlatform)platform
                      item:(DDLinkupItem *)linkupItem{
    if (platform == DDSSPlatformWeChat) {
        return [self.wechatHandler JumpToBizProfileWithExtMsg:linkupItem.extMsg username:linkupItem.username profileType:linkupItem.linkupType];
    }
    return NO;
}


#pragma mark - Private Methods

- (BOOL)respondsToSelectorWithProtocol:(id<DDSocialShareContentProtocol>)protocol type:(DDSSContentType)shareType{
    if (shareType == DDSSContentTypeText) {
        return [self respondsToSelectorWithTextProtocol:(id<DDSocialShareTextProtocol>)protocol];
    }
    else if (shareType == DDSSContentTypeImage){
        return [self respondsToSelectorWithImageProtocol:(id<DDSocialShareImageProtocol>)protocol];
    }
    else if (shareType == DDSSContentTypeWebPage){
        return [self respondsToSelectorWithWebPageProtocol:(id<DDSocialShareWebPageProtocol>)protocol];
    }
    else {
        return NO;
    }
}

- (BOOL)respondsToSelectorWithTextProtocol:(id<DDSocialShareTextProtocol>)protocol{
    return [self protocol:protocol respondsToSelector:@selector(ddShareText)];
}

- (BOOL)respondsToSelectorWithImageProtocol:(id<DDSocialShareImageProtocol>)protocol{
    [self protocol:protocol respondsToSelector:@selector(ddShareImageWithImageData)];
    [self protocol:protocol respondsToSelector:@selector(ddShareImageWithTitle)];
    [self protocol:protocol respondsToSelector:@selector(ddShareImageWithDescription)];
    [self protocol:protocol respondsToSelector:@selector(ddShareImageWithWebpageUrl)];
    return YES;
}

- (BOOL)respondsToSelectorWithWebPageProtocol:(id<DDSocialShareWebPageProtocol>)protocol{
    [self protocol:protocol respondsToSelector:@selector(ddShareWebPageWithTitle)];
    [self protocol:protocol respondsToSelector:@selector(ddShareWebPageWithDescription)];
    [self protocol:protocol respondsToSelector:@selector(ddShareWebPageWithImageData)];
    [self protocol:protocol respondsToSelector:@selector(ddShareWebPageWithWebpageUrl)];
    [self protocol:protocol respondsToSelector:@selector(ddShareWebPageWithObjectID)];
    return YES;
}

- (BOOL)protocol:(id)protocol respondsToSelector:(SEL)selector{
    if (![protocol respondsToSelector:selector]) {
        NSAssert(NO,([NSString stringWithFormat:@"%@ not implementation method %@ ",NSStringFromProtocol(protocol),NSStringFromSelector(selector)]));
    }
    return YES;
}

#pragma mark - Getter and Setter

- (DDWeChatHandler *)wechatHandler{
    if (!_wechatHandler) {
        _wechatHandler = [[DDWeChatHandler alloc] init];
    }
    return _wechatHandler;
}

- (DDSinaHandler *)sinaHandler{
    if (!_sinaHandler) {
        _sinaHandler = [[DDSinaHandler alloc] init];
    }
    return _sinaHandler;
}

- (DDTencentHandler *)tencentHandler{
    if (!_tencentHandler) {
        _tencentHandler = [[DDTencentHandler alloc] init];
    }
    return _tencentHandler;
}

- (DDFacebookHandler *)facebookHandler{
    if (!_facebookHandler) {
        _facebookHandler = [[DDFacebookHandler alloc] init];
    }
    return _facebookHandler;
}

- (DDGoogleHandler *)googleHandler{
    if (!_googleHandler) {
        _googleHandler = [[DDGoogleHandler alloc] init];
    }
    return _googleHandler;
}

- (DDTwitterHandler *)twitterHandler{
    if (!_twitterHandler) {
        _twitterHandler = [[DDTwitterHandler alloc] init];
    }
    return _twitterHandler;
}

- (DDMiLiaoHandler *)miliaoHandler{
    if (!_miliaoHandler) {
        _miliaoHandler = [[DDMiLiaoHandler alloc] init];
    }
    return _miliaoHandler;
}
@end
