//
//  DDMIHandler.m
//  HMLoginDemo
//
//  Created by lilingang on 15/8/3.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import "DDMIHandler.h"

#import "DDMILoginViewController.h"
#import "DDMIAuthViewController.h"

#import "DDMIRequestHandle.h"

#import "DDAuthItem.h"
#import "DDUserInfoItem.h"

@interface DDMIHandler ()<DDMIAuthViewControllerDelegate>

@property (nonatomic, copy) NSString *appKey;

@property (nonatomic, copy) NSString *redirectUrl;

@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, strong) DDMIRequestHandle *requestHandle;

@property (nonatomic, copy) DDSSAuthEventHandler authEventHandle;

@property (nonatomic, assign) DDSSAuthMode  authMode;

@end

@implementation DDMIHandler

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc");
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(miLoginAuthNotification:) name:DDMILoginAuthNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(miLoginCancelNotification:) name:DDMILoginCancelNotification object:nil];
    }
    return self;
}

#pragma mark - Private Methods

- (void)presetLoginViewControllerInViewController:(UIViewController *)viewController{
    DDMILoginViewController *loginViewController = [[DDMILoginViewController alloc] initWithRequestHandle:self.requestHandle];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [viewController presentViewController:self.navigationController animated:YES completion:nil];
}

- (void)disMissWithCompletion:(void (^)(void))completion{
    __weak __typeof(&*self)weakSelf = self;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        weakSelf.navigationController = nil;
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - DDMIAuthViewControllerDelegate

- (void)authViewController:(DDMIAuthViewController *)viewController successWithResponse:(NSDictionary *)response{
    __weak __typeof(&*self)weakSelf = self;
    [self disMissWithCompletion:^{
        DDAuthItem *authItem = [[DDAuthItem alloc] init];
        authItem.rawObject = response;
        if (self.authMode == DDSSAuthModeCode) {
            authItem.thirdToken = [response objectForKey:@"code"];
        } else {
            authItem.thirdToken = [response objectForKey:@"access_token"];
        }
        weakSelf.authEventHandle(DDSSPlatformMI,DDSSAuthStateSuccess,authItem,nil);
        weakSelf.authEventHandle = nil;
    }];
}

- (void)authViewController:(DDMIAuthViewController *)viewController failedWithError:(NSError *)error{
    __weak __typeof(&*self)weakSelf = self;
    [self disMissWithCompletion:^{
        weakSelf.authEventHandle(DDSSPlatformMI,DDSSAuthStateFail,nil,error);
        weakSelf.authEventHandle = nil;
    }];
}

#pragma mark - Notification

- (void)miLoginAuthNotification:(NSNotification *)notification{
    DDMIAuthViewController *viewController = [[DDMIAuthViewController alloc] initWithAppid:self.appKey redirectUrl:self.redirectUrl];
    viewController.delegate = self;
    viewController.authMode = self.authMode;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)miLoginCancelNotification:(NSNotification *)notification{
    __weak __typeof(&*self)weakSelf = self;
    [self disMissWithCompletion:^{
        weakSelf.authEventHandle(DDSSPlatformMI,DDSSAuthStateCancel,nil,nil);
        weakSelf.authEventHandle = nil;
    }];
}

#pragma mark - Getter and Setter

- (DDMIRequestHandle *)requestHandle{
    if (!_requestHandle) {
        _requestHandle = [[DDMIRequestHandle alloc] init];
    }
    return _requestHandle;
}
@end

@implementation DDMIHandler (DDSocialHandlerProtocol)

- (void)registerWithAppKey:(NSString *)appKey
                 appSecret:(NSString *)appSecret
               redirectURL:(NSString *)redirectURL
            appDescription:(NSString *)appDescription {
    self.redirectUrl = redirectURL;
    self.appKey = appKey;
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
    [self presetLoginViewControllerInViewController:viewController];
    return YES;
}

- (BOOL)getUserInfoWithAuthItem:(DDAuthItem *)authItem
                       handler:(DDSSUserInfoEventHandler)handler{
    if (!handler) {
        return NO;
    }
    NSDictionary *dict = authItem.rawObject;
    NSString *token = [dict objectForKey:@"access_token"];
    if (!token) {
        NSLog(@"获取小米个人信息需要使用token方式授权");
        return NO;
    }
    return [self.requestHandle getProfileWithAccessToken:token clientId:self.appKey completeHandler:^(NSDictionary *responseDict, NSError *connectionError) {
        if (connectionError) {
            handler(nil,connectionError);
        } else {
            DDUserInfoItem *userItem = [[DDUserInfoItem alloc] initWithPlatForm:DDSSPlatformMI rawObject:responseDict];
            handler(userItem, nil);
        }
    }];
}

@end
