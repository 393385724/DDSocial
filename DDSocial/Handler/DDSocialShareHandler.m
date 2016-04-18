//
//  DDSocialShareHandler.m
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDSocialShareHandler.h"
#import "DDSocialHandlerProtocol.h"
#import <UIKit/UIKit.h>

@interface DDSocialShareHandler ()

@property (nonatomic, strong) id<DDSocialHandlerProtocol> wechatHandler;
@property (nonatomic, strong) id<DDSocialHandlerProtocol> sinaHandler;
@property (nonatomic, strong) id<DDSocialHandlerProtocol> tencentHandler;
@property (nonatomic, strong) id<DDSocialHandlerProtocol> facebookHandler;
@property (nonatomic, strong) id<DDSocialHandlerProtocol> googleHandler;
@property (nonatomic, strong) id<DDSocialHandlerProtocol> twitterHandler;
@property (nonatomic, strong) id<DDSocialHandlerProtocol> miliaoHandler;

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
    Class class = nil;
    if (platform == DDSSPlatformWeChat) {
        class = NSClassFromString(@"DDWeChatHandler");
    } else if (platform == DDSSPlatformSina){
        class = NSClassFromString(@"DDSinaHandler");
    } else if (platform == DDSSPlatformQQ){
        class = NSClassFromString(@"DDTencentHandler");
    } else if (platform == DDSSPlatformFacebook){
        class = NSClassFromString(@"DDFacebookHandler");
    } else if (platform == DDSSPlatformTwitter){
        class = NSClassFromString(@"DDTwitterHandler");
    } else if (platform == DDSSPlatformGoogle){
        class = NSClassFromString(@"DDGoogleHandler");
    } else if (platform == DDSSPlatformMiLiao){
        class = NSClassFromString(@"DDMiLiaoHandler");
    }
    if (class) {
        return [class isInstalled];
    } else {
        return NO;
    }
}

+ (BOOL)canShareToScence:(DDSSScene)scene{
    Class class = nil;
    if (scene == DDSSSceneWXSession || scene == DDSSSceneWXTimeline) {
        class = NSClassFromString(@"DDWeChatHandler");
    } else if (scene == DDSSSceneSina){
        class = NSClassFromString(@"DDSinaHandler");
    } else if (scene == DDSSSceneQQFrined || scene == DDSSSceneQZone){
        class = NSClassFromString(@"DDTencentHandler");
    } else if (scene == DDSSSceneFBSession){
        class = NSClassFromString(@"DDFacebookHandler");
    } else if (scene == DDSSSceneTwitter){
        class = NSClassFromString(@"DDTwitterHandler");
    } else if (scene == DDSSSceneMiLiaoSession || scene == DDSSSceneMiLiaoTimeline){
        class = NSClassFromString(@"DDMiLiaoHandler");
    }
    if (class) {
        return [class canShare];
    } else {
        return NO;
    }
}

- (void)registerPlatform:(DDSSPlatform)platform {
    [self registerPlatform:platform appKey:@"" appSecret:@"" redirectURL:@"" appDescription:@""];
}

- (void)registerPlatform:(DDSSPlatform)platform
                  appKey:(NSString *)appKey{
    [self registerPlatform:platform appKey:appKey appSecret:@"" redirectURL:@"" appDescription:@""];
}

- (void)registerPlatform:(DDSSPlatform)platform
                  appKey:(NSString *)appKey
               appSecret:(NSString *)appSecret {
    [self registerPlatform:platform appKey:appKey appSecret:appSecret redirectURL:@"" appDescription:@""];
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
          appDescription:(NSString *)appDescription {
    if (platform == DDSSPlatformWeChat) {
        [self.wechatHandler registerWithAppKey:appKey appSecret:appSecret redirectURL:redirectURL appDescription:appDescription];
    } else if (platform == DDSSPlatformSina){
        [self.sinaHandler registerWithAppKey:appKey appSecret:appSecret redirectURL:redirectURL appDescription:appDescription];
    } else if (platform == DDSSPlatformQQ){
        [self.tencentHandler registerWithAppKey:appKey appSecret:appSecret redirectURL:redirectURL appDescription:appDescription];
    } else if (platform == DDSSPlatformFacebook){
        [self.facebookHandler registerWithAppKey:appKey appSecret:appSecret redirectURL:redirectURL appDescription:appDescription];
    } else if (platform == DDSSPlatformGoogle){
        [self.googleHandler registerWithAppKey:appKey appSecret:appSecret redirectURL:redirectURL appDescription:appDescription];
    } else if (platform == DDSSPlatformTwitter){
        [self.twitterHandler registerWithAppKey:appKey appSecret:appSecret redirectURL:redirectURL appDescription:appDescription];
    } else if (platform == DDSSPlatformMiLiao){
        [self.miliaoHandler registerWithAppKey:appKey appSecret:appSecret redirectURL:redirectURL appDescription:appDescription];
    }
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    BOOL canWeChatOpen = [self.wechatHandler application:application handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (canWeChatOpen) {
        return YES;
    }
    BOOL canSinaOpen = [self.sinaHandler application:application handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (canSinaOpen) {
        return YES;
    }
    BOOL canQQOpen = [self.tencentHandler application:application handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (canQQOpen) {
        return YES;
    }
    BOOL canFacebookOpen = [self.facebookHandler application:application handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (canFacebookOpen) {
        return YES;
    }
    BOOL canTwitterOpen = [self.twitterHandler application:application handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (canTwitterOpen) {
        return YES;
    }
    BOOL canGooleOpen = [self.googleHandler application:application handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (canGooleOpen) {
        return YES;
    }
    BOOL canMiliaoOpen = [self.miliaoHandler application:application handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
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
        return [self.sinaHandler authWithMode:authMode controller:viewController handler:handler];
    } else if (platform == DDSSPlatformQQ){
        return [self.tencentHandler authWithMode:authMode controller:viewController handler:handler];
    } else if (platform == DDSSPlatformFacebook){
        return [self.facebookHandler authWithMode:authMode controller:viewController handler:handler];
    } else if (platform == DDSSPlatformTwitter){
        return [self.twitterHandler authWithMode:authMode controller:viewController handler:handler];
    } else if (platform == DDSSPlatformGoogle){
        return [self.googleHandler authWithMode:authMode controller:viewController handler:handler];
    } else if (platform == DDSSPlatformMiLiao){
        return [self.miliaoHandler authWithMode:authMode controller:viewController handler:handler];
    }
    return NO;
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
       return [self.wechatHandler shareWithController:viewController shareScene:shareScene contentType:contentType protocol:protocol handler:handler];
    } else if (platform == DDSSPlatformSina){
        return [self.sinaHandler shareWithController:viewController shareScene:shareScene contentType:contentType protocol:protocol handler:handler];
    } else if (platform == DDSSPlatformQQ){
        return [self.tencentHandler shareWithController:viewController shareScene:shareScene contentType:contentType protocol:protocol handler:handler];
    } else if (platform == DDSSPlatformFacebook){
        return [self.facebookHandler shareWithController:viewController shareScene:shareScene contentType:contentType protocol:protocol handler:handler];
    } else if (platform == DDSSPlatformTwitter){
        return [self.twitterHandler shareWithController:viewController shareScene:shareScene contentType:contentType protocol:protocol handler:handler];
    } else if (platform == DDSSPlatformGoogle){
        return [self.googleHandler shareWithController:viewController shareScene:shareScene contentType:contentType protocol:protocol handler:handler];
    } else if (platform == DDSSPlatformMiLiao){
        return [self.miliaoHandler shareWithController:viewController shareScene:shareScene contentType:contentType protocol:protocol handler:handler];
    }
    return NO;
}

- (BOOL)linkupWithPlatform:(DDSSPlatform)platform
                      item:(DDLinkupItem *)linkupItem{
    if (platform == DDSSPlatformWeChat) {
        return [self.wechatHandler linkupWithItem:linkupItem];
    } else if (platform == DDSSPlatformSina){
        return [self.sinaHandler linkupWithItem:linkupItem];
    } else if (platform == DDSSPlatformQQ){
        return [self.tencentHandler linkupWithItem:linkupItem];
    } else if (platform == DDSSPlatformFacebook){
        return [self.facebookHandler linkupWithItem:linkupItem];
    } else if (platform == DDSSPlatformTwitter){
        return [self.twitterHandler linkupWithItem:linkupItem];
    } else if (platform == DDSSPlatformGoogle){
        return [self.googleHandler linkupWithItem:linkupItem];
    } else if (platform == DDSSPlatformMiLiao){
        return [self.miliaoHandler linkupWithItem:linkupItem];
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

- (id<DDSocialHandlerProtocol>)wechatHandler{
    if (!_wechatHandler) {
        _wechatHandler = [NSClassFromString(@"DDWeChatHandler") new];
    }
    return _wechatHandler;
}

- (id<DDSocialHandlerProtocol>)sinaHandler{
    if (!_sinaHandler) {
        _sinaHandler = [NSClassFromString(@"DDSinaHandler") new];
    }
    return _sinaHandler;
}

- (id<DDSocialHandlerProtocol>)tencentHandler{
    if (!_tencentHandler) {
        _tencentHandler = [NSClassFromString(@"DDTencentHandler") new];
    }
    return _tencentHandler;
}

- (id<DDSocialHandlerProtocol>)facebookHandler{
    if (!_facebookHandler) {
        _facebookHandler = [NSClassFromString(@"DDFacebookHandler") new];
    }
    return _facebookHandler;
}

- (id<DDSocialHandlerProtocol>)googleHandler{
    if (!_googleHandler) {
        _googleHandler = [NSClassFromString(@"DDGoogleHandler") new];
    }
    return _googleHandler;
}

- (id<DDSocialHandlerProtocol>)twitterHandler{
    if (!_twitterHandler) {
        _twitterHandler = [NSClassFromString(@"DDTwitterHandler") new];
    }
    return _twitterHandler;
}

- (id<DDSocialHandlerProtocol>)miliaoHandler{
    if (!_miliaoHandler) {
        _miliaoHandler = [NSClassFromString(@"DDMiLiaoHandler") new];
    }
    return _miliaoHandler;
}
@end
