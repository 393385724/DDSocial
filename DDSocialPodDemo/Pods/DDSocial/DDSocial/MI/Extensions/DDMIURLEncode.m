//
//  DDMIURLEncode.m
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/29.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDMIURLEncode.h"

@implementation DDMIURLEncode

+ (NSString *)encodeString:(NSString*)unencodedString{
    NSString *encodedString = [unencodedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    return encodedString;
}

+ (NSString *)decodeString:(NSString*)encodedString{
    NSString *decodedString = [encodedString stringByRemovingPercentEncoding];
    return decodedString;
}

@end
