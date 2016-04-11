//
//  DDMainViewController.m
//  DDSocialDemo
//
//  Created by lilingang on 16/4/5.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDMainViewController.h"
#import "DDAuthTableViewController.h"
#import "DDShareTableViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>

@interface DDMainViewController ()<GIDSignInUIDelegate>

@end

@implementation DDMainViewController

- (IBAction)authButtonAction:(id)sender {
    DDAuthTableViewController *viewController = [[DDAuthTableViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)shareButtonAction:(id)sender {
    DDShareTableViewController *viewController = [[DDShareTableViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)googleLoginButtonAction:(id)sender {
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signIn];
}

// The sign-in flow has finished selecting how to proceed, and the UI should no longer display
// a spinner or other "please wait" element.
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error{
    
}

// If implemented, this method will be invoked when sign in needs to display a view controller.
// The view controller should be displayed modally (via UIViewController's |presentViewController|
// method, and not pushed unto a navigation controller's stack.
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController{
    [self presentViewController:viewController animated:YES completion:nil];
}

// If implemented, this method will be invoked when sign in needs to dismiss a view controller.
// Typically, this should be implemented by calling |dismissViewController| on the passed
// view controller.
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
