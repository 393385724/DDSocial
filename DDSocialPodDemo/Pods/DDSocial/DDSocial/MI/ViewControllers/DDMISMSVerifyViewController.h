//
//  DDMISMSVerifyViewController.h
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/29.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDMIBaseViewController.h"

@class DDMIRequestHandle;

@interface DDMISMSVerifyViewController : DDMIBaseViewController

- (instancetype)initWithRequestHandle:(DDMIRequestHandle *)requestHandle
                          phoneNumber:(NSString *)phoneNumber
                             passWord:(NSString *)password;

@end
