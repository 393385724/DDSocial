//
//  DDMIHandler.m
//  HMLoginDemo
//
//  Created by lilingang on 15/8/3.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import "DDMIHandler.h"
#import <MiPassport/MiPassport.h>
#import "DDAuthItem.h"
#import "DDUserInfoItem.h"

static NSString * const DDMIGetProfileAPISuffix = @"user/profile";

@interface DDMIHandler ()<MPSessionDelegate, MiPassportRequestDelegate>

@property (nonatomic, strong) MiPassport *miPassport;

@property (nonatomic, copy) DDSSAuthEventHandler authEventHandle;

@property (nonatomic, copy) DDSSUserInfoEventHandler userInfoEventHandler;

@property (nonatomic, assign) DDSSAuthMode  authMode;

@end

@implementation DDMIHandler


#pragma mark - MPSessionDelegate

/**
 * Called when the user successfully logged in.
 */
- (void)passportDidLogin:(MiPassport *)passport {
    DDAuthItem *authItem = [[DDAuthItem alloc] init];
    
    authItem.thirdToken = passport.accessToken;
    authItem.thirdId = passport.appId;
    authItem.rawObject = passport;
    
    if (self.authEventHandle) {
        self.authEventHandle(DDSSPlatformMI,DDSSAuthStateSuccess,authItem,nil);
    }
}
/**
 * Called when the user failed to log in.
 */
- (void)passport:(MiPassport *)passport failedWithError:(NSError *)error {
    if (self.authEventHandle) {
        self.authEventHandle(DDSSPlatformMI,DDSSAuthStateFail,nil,nil);
    }
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)passportDidCancel:(MiPassport *)passport {
    if (self.authEventHandle) {
        self.authEventHandle(DDSSPlatformMI,DDSSAuthStateCancel,nil,nil);
    }
}

/**
 * Called when the user logged out.
 */
- (void)passportDidLogout:(MiPassport *)passport {
    
}

/**
 * Called when the user get code.
 */
- (void)passport:(MiPassport *)passport didGetCode:(NSString *)code {
    DDAuthItem *authItem = [[DDAuthItem alloc] init];
    authItem.thirdToken = code;
    authItem.thirdId = passport.appId;
    authItem.rawObject = passport;
    
    if (self.authEventHandle) {
        self.authEventHandle(DDSSPlatformMI,DDSSAuthStateSuccess,authItem,nil);
    }
}

/**
 * Called when access token expired.
 */
- (void)passport:(MiPassport *)passport accessTokenInvalidOrExpired:(NSError *)error {
    NSLog(@"passport accesstoken invalid or expired");
}

#pragma mark - MPRequestDelegate
/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(MiPassportRequest *)request {
    
}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(MiPassportRequest *)request didReceiveResponse:(NSURLResponse *)response {
    
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(MiPassportRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"request did fail with error code: %zd", [error code]);
    if ([request.url hasSuffix:DDMIGetProfileAPISuffix]) {
        self.userInfoEventHandler(nil, error);
        self.userInfoEventHandler = nil;
    }
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(MiPassportRequest *)request didLoad:(id)result {
    if ([request.url hasSuffix:DDMIGetProfileAPISuffix]) {
        NSInteger code = [[result objectForKey:@"code"] integerValue];
        if (code == 0) {
            NSDictionary *dataDict = [result objectForKey:@"data"];
            DDUserInfoItem *infoItem = [[DDUserInfoItem alloc] initWithPlatForm:DDSSPlatformMI rawObject:dataDict];
            self.userInfoEventHandler(infoItem,nil);
            self.userInfoEventHandler = nil;
        } else {
            NSError *error = [NSError errorWithDomain:@"服务器错误" code:code userInfo:result];
            [self request:request didFailWithError:error];
        }
    }
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(MiPassportRequest *)request didLoadRawResponse:(NSData *)data {

}

@end

@implementation DDMIHandler (DDSocialHandlerProtocol)

- (void)registerWithAppKey:(NSString *)appKey
                 appSecret:(NSString *)appSecret
               redirectURL:(NSString *)redirectURL
            appDescription:(NSString *)appDescription {
    NSAssert(appKey, @"appKey 不能为空");
    self.miPassport = [[MiPassport alloc] initWithAppId:appKey
                                            redirectUrl:redirectURL andDelegate:self];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [self.miPassport handleOpenURL:url];
}

- (BOOL)authWithMode:(DDSSAuthMode)mode
          controller:(UIViewController *)viewController
             handler:(DDSSAuthEventHandler)handler{
    if (!handler) {
        return NO;
    }
    self.authMode = mode;
    self.authEventHandle = handler;
    self.authEventHandle(DDSSPlatformMI,DDSSAuthStateBegan,nil,nil);
    if (mode == DDSSAuthModeCode) {
        [self.miPassport applyPassCodeWithPermissions:nil];
    } else {
        [self.miPassport loginWithPermissions:nil];
    }
    return YES;
}

- (BOOL)getUserInfoWithAuthItem:(DDAuthItem *)authItem
                       handler:(DDSSUserInfoEventHandler)handler{
    if (!handler) {
        return NO;
    }
    self.userInfoEventHandler = handler;
    [self.miPassport requestWithURL:DDMIGetProfileAPISuffix params:[NSMutableDictionary dictionaryWithObject:self.miPassport.appId forKey:@"clientId"] httpMethod:@"GET" delegate:self];
    
    return YES;
}

@end
