//
//  DDSocialAuthHandler.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialAuthDefs.h"
#import "DDAuthItem.h"

@class UIViewController;

@interface DDSocialAuthHandler : NSObject

+ (DDSocialAuthHandler *)sharedInstance;

- (void)registerPlatform:(DDAuthPlatform)platform
             redirectURL:(NSString *)redirectURL;

- (BOOL)authWithPlatform:(DDAuthPlatform)authPlatform
                    mode:(DDAuthMode)mode
              controller:(UIViewController *)viewController
             authHandler:(DDAuthEventHandler)authHandler;
@end
