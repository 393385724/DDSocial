//
//  DDMIHelpViewController.m
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/29.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDMIHelpViewController.h"

@interface DDMIHelpViewController ()

@end

@implementation DDMIHelpViewController{
    NSString *_phoneNumberString;
}

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumberString{
    self = [super init];
    if (self) {
        _phoneNumberString = phoneNumberString;
    }
    return self;
}

#pragma mark - Template Methods

- (NSString *)loadWholeURLString{
    return [NSString stringWithFormat:@"https://account.xiaomi.com/pass/retrieve/prompt?externalId=%@&type=bind&_locale=%@",_phoneNumberString,MILocal(@"cn")];
}


@end
