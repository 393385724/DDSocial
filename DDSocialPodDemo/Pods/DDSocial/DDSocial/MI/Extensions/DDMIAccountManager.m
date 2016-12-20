//
//  DDMIAccountManager.m
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/29.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDMIAccountManager.h"

@implementation DDMIAccountManager

+ (void)saveUserAccount:(NSString *)account{
    if (account && [account length]) {
        [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"DDMIAccount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)userAccount{
    NSString *account = [[NSUserDefaults standardUserDefaults] stringForKey:@"DDMIAccount"];
    if (account && [account length]) {
        return account;
    }
    return @"";
}

@end
