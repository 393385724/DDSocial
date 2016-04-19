//
//  DDMIHandler.h
//  HMLoginDemo
//
//  Created by lilingang on 15/8/3.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//
/// info.plist 配置 CFBundleURLName为xiaomi

#import <Foundation/Foundation.h>
#import "DDSocialHandlerProtocol.h"

@interface DDMIHandler : NSObject

@end

@interface DDMIHandler (DDSocialHandlerProtocol)<DDSocialHandlerProtocol>

@end
