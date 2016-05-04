//
//  DDMIURLEncode.h
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/29.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMIURLEncode : NSObject

/**
 *  @brief 编码字符串
 *
 *  @param unencodedString 需要编码的字符串
 *
 *  @return 编码后的字符传
 */
+ (NSString *)encodeString:(NSString*)unencodedString;

/**
 *  @brief 解码字符串
 *
 *  @param unencodedString 需要解码的字符串
 *
 *  @return 解码后的字符传
 */
+ (NSString *)decodeString:(NSString*)encodedString;

@end
