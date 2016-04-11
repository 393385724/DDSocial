//
//  DDGoogleHandler.m
//  DDSocialDemo
//
//  Created by lilingang on 16/4/11.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDGoogleHandler.h"
#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GoogleSignIn/GIDSignIn.h>

@interface DDGoogleHandler ()<GIDSignInDelegate, GIDSignInUIDelegate>

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, copy) DDSSAuthEventHandler authEventHandler;

@end

@implementation DDGoogleHandler

- (BOOL)registerApp{
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    if (configureError) {
        return NO;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}

- (BOOL)authWithViewController:(UIViewController *)viewController
                       handler:(DDSSAuthEventHandler)handler{
    if (handler) {
        return NO;
    }
    self.authEventHandler = handler;
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signIn];
    return YES;
}

#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    // ...
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

#pragma mark - GIDSignInUIDelegate

// The sign-in flow has finished selecting how to proceed, and the UI should no longer display
// a spinner or other "please wait" element.
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error{
    
}

// If implemented, this method will be invoked when sign in needs to display a view controller.
// The view controller should be displayed modally (via UIViewController's |presentViewController|
// method, and not pushed unto a navigation controller's stack.
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController{
    [self.viewController presentViewController:viewController animated:YES completion:^{
        
    }];
}

// If implemented, this method will be invoked when sign in needs to dismiss a view controller.
// Typically, this should be implemented by calling |dismissViewController| on the passed
// view controller.
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController{
    [self.viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
