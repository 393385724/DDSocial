//
//  DDMITelephoneRule.h
//  DDMISDKDemo
//
//  Created by lilingang on 16/5/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMITelephoneRule : NSObject

- (instancetype)initWithDefaultRule;

- (NSString *)formatPhoneNum:(NSString *)phoneNum;

@end
