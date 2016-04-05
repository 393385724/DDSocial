//
//  DDSocialAuthHandler.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialTypeDefs.h"
#import "DDSocialEventDefs.h"
#import "DDAuthItem.h"

@class UIViewController;

/**
 *  @brief 授权类
 */
@interface DDSocialAuthHandler : NSObject

+ (DDSocialAuthHandler *)sharedInstance;

- (void)registerMIApp:(NSString *)appid
          redirectURL:(NSString *)redirectURL;

- (BOOL)authWithPlatform:(DDSSPlatform)authPlatform
              controller:(UIViewController *)viewController
             authHandler:(DDSSAuthEventHandler)authHandler;
@end
