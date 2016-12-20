//
//  DDMIForgetPasswordViewController.m
//  midong
//
//  Created by lilingang on 16/4/23.
//  Copyright © 2016年 HM IOS Team. All rights reserved.
//

#import "DDMIForgetPasswordViewController.h"

NSString *const DDMIResetPasswordURL =  @"https://account.xiaomi.com/pass/forgetPassword?&_locale=%@";
NSString *const DDMIServiceLoginURL =  @"https://account.xiaomi.com/pass/serviceLogin";


@interface DDMIForgetPasswordViewController ()

@end

@implementation DDMIForgetPasswordViewController

#pragma mark - Template Methods

- (NSString *)loadWholeURLString{
    NSArray *languages = [[NSBundle mainBundle] preferredLocalizations];
    NSString *preferredLang = [languages objectAtIndex:0];
    return [NSString stringWithFormat:DDMIResetPasswordURL,preferredLang];
}

- (BOOL)shouldStartLoadWithRequest:(NSURLRequest *)request{
    if ([request.URL.absoluteString hasPrefix:DDMIServiceLoginURL]) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    } else {
        return YES;
    }
}

@end
