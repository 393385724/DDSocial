//
//  DDMIVerifyPasswordTool.h
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/27.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMIVerifyPasswordTool : NSObject

/**
 *  @brief 验证是不是有效的密码
 *
 *  @param passwordString 需要验证的字符串
 *
 *  @return YES?有效：无效
 */
+ (BOOL)verifyPasswordString:(NSString*)passwordString;

@end
