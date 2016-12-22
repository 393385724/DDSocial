//
//  DDMIVerifyPasswordTool.m
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/27.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDMIVerifyPasswordTool.h"
#import "DDMIDefines.h"

/*
 * 合法的密码文字
 */
#define LEGAL_PWD               @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()`~-_=+[{]}\\|;:\'\",<.>/?"

@implementation DDMIVerifyPasswordTool

+ (BOOL)verifyPasswordString:(NSString*)passwordString{
    if (MIIsEmptyString(passwordString) ||
        [self isChinese:passwordString] ||
        [self isAllDigitals:passwordString] ||
        [self isAllLetters:passwordString] ||
        [self isAllSigns:passwordString]) {
        return NO;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:LEGAL_PWD] invertedSet];
    NSString *filtered = [[passwordString componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if ([filtered length] >= 8 && [filtered length] <= 16) {
        return YES;
    }
    return NO;
}

#pragma mark - Private Methods
/**
 *  @brief 判断字符串是不是汉字
 *
 *  @param string 需要检查的字符串
 *
 *  @return YES?是:不是
 */
+ (BOOL)isChinese:(NSString *)string{
    for (int i = 0; i < string.length; i++) {
        //0x4e00-0x9fcc：中日韩字符
        //0x3000-0x303f：中日韩全角ASCII标点符号
        //0xff01-0xff5e：中日韩标点符号
        unichar curChar = [string characterAtIndex:i];
        if ((curChar >= 0x4e00 && curChar <= 0x9fcc) ||
            (curChar >= 0x3000 && curChar <= 0x303f) ||
            (curChar >= 0xff01 && curChar <= 0xff5e)) {
            return YES;
        }
    }
    return NO;
}

/**
 *  @brief 判断字符串是不是纯数字
 *
 *  @param string 需要检查的字符串
 *
 *  @return YES?是:不是
 */
+ (BOOL)isAllDigitals:(NSString *)string{
    NSRegularExpression *allDigital = [NSRegularExpression regularExpressionWithPattern:@"^\\d+$"
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:nil];
    NSUInteger countDigital = [allDigital numberOfMatchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, [string length])];
    return countDigital;
}

/**
 *  @brief 判断字符串是不是纯字母
 *
 *  @param string 需要检查的字符串
 *
 *  @return YES?是:不是
 */
+ (BOOL)isAllLetters:(NSString *)string{
    NSRegularExpression *allLetter = [NSRegularExpression regularExpressionWithPattern:@"^[A-Za-z]+$"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
    NSUInteger countLetter = [allLetter numberOfMatchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, [string length])];
    return countLetter;
}

/**
 *  @brief 判断字符串是不是纯符号
 *
 *  @param string 需要检查的字符串
 *
 *  @return YES?是:不是
 */
+ (BOOL)isAllSigns:(NSString *)string{
    NSRegularExpression *allSign = [NSRegularExpression regularExpressionWithPattern:@"^\\W+$"
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:nil];
    NSUInteger countSign = [allSign numberOfMatchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, [string length])];
    return countSign;
}

@end
