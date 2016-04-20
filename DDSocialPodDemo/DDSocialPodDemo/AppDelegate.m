//
//  AppDelegate.m
//  DDSocialPodDemo
//
//  Created by lilingang on 16/4/20.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "AppDelegate.h"
#import "DDMainViewController.h"

#import "DDSocialShareHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    DDMainViewController *viewController = [[DDMainViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformMI appKey:@"2882303761517373163"redirectURL:@"http://xiaomi.com"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformWeChat appKey:@"wxd930ea5d5a258f4f"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformQQ appKey:@"222222"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformSina appKey:@"2045436852"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformFacebook appKey:@"125938537776820"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformMiLiao appKey:@"ml6df2cb3b3cc22134"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformTwitter appKey:@"4r5BMrTUl5W3lOwBLSskd9VUb" appSecret:@"8pdLS9spOkf00HE2HetoUxb8bVB6YTxoFvoRwcyq9gl2XDRJBz"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformGoogle];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[DDSocialShareHandler sharedInstance] application:application handleOpenURL:url sourceApplication:nil annotation:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[DDSocialShareHandler sharedInstance] application:application handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    return [[DDSocialShareHandler sharedInstance] application:app openURL:url options:options];
}
@end
