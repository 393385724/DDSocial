//
//  DDSocialHandlerProtocol.h
//  Pods
//
//  Created by CocoaBob on 18/04/16.
//
//

#import <Foundation/Foundation.h>

@protocol DDSocialShareContentProtocol;
@class DDLinkupItem;

@protocol DDSocialHandlerProtocol <NSObject>

+ (BOOL)isInstalled;
+ (BOOL)canShare;

- (BOOL)registerWithAppKey:(NSString *)appKey
                 appSecret:(NSString *)appSecret
               redirectURL:(NSString *)redirectURL
            appDescription:(NSString *)appDescription;
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;
- (BOOL)authWithMode:(DDSSAuthMode)mode
          controller:(UIViewController *)viewController
             handler:(DDSSAuthEventHandler)handler;
- (BOOL)shareWithController:(UIViewController *)viewController
                 shareScene:(DDSSScene)shareScene
                contentType:(DDSSContentType)contentType
                   protocol:(id<DDSocialShareContentProtocol>)protocol
                    handler:(DDSSShareEventHandler)handler;
- (BOOL)linkupWithItem:(DDLinkupItem *)linkupItem;

@end