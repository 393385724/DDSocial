//
//  DDMITelephoneRule.m
//  DDMISDKDemo
//
//  Created by lilingang on 16/5/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDMITelephoneRule.h"
#import "DDMIDefines.h"

#define MI_CHAR_ZERO (@"0")

@implementation DDMITelephoneRule{
    NSString    *_cn;
    NSString    *_iso;
    NSString    *_ic;
    NSArray     *_len;
    NSArray     *_mc;
    
    NSString    *num_ic;
    NSString    *plus_ic;
}

- (instancetype)initWithDefaultRule{//默认是中国
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"China",@"cn",
                         @"86",@"ic",
                         @"CN",@"iso",
                         [NSArray arrayWithObjects:@"11", nil],@"len",
                         [NSArray arrayWithObjects:@"13",@"14",@"15",@"18", nil],@"mc",
                         nil];
    return [self initWithDic:dic];
}

- (instancetype) initWithDic:(NSDictionary *)dic{
    self = [super init];
    _cn =  [dic objectForKey:@"cn"];
    _iso = [dic objectForKey:@"iso"];
    _ic =  [dic objectForKey:@"ic"];
    _len = [dic objectForKey:@"len"];
    _mc =  [dic objectForKey:@"mc"];
    
    num_ic = [NSString stringWithFormat:@"00%@",_ic]; //0086 for exp
    plus_ic = [NSString stringWithFormat:@"+%@",_ic]; //+86 for exp
    return self;
}

// 返回为nil 表示匹配失败;匹配成功 直接返回处理后所得得字符串
- (NSString *)matchAndReturn:(NSString *)phoneNum{
    // 做一个预处理 将国家码和可能出现的填位0去除
    NSString *formattedNum = [self formatPhoneNum:phoneNum];
    if ([self matchLEN:formattedNum]&&[self matchMC:formattedNum]) {
        // 国内电话 直接返回电话号码
        if ([_ic isEqualToString:@"86"] || MIIsEmptyString(_ic)) {
            return formattedNum;
        }else {
            return [NSString stringWithFormat:@"%@%@",plus_ic,formattedNum];
        }
    }else {
        return nil;
    }
}

// 国际号码 可能出现 <国际号>＋0＋<电话号码的情况> 这时候我们需要格式化返回的内容是<电话号码>
- (NSString *)formatPhoneNum:(NSString *)phoneNum{
    NSString *cutPreStr;
    if ([phoneNum hasPrefix:plus_ic]) {
        cutPreStr = [phoneNum substringFromIndex:[plus_ic length]];
    }else if ([phoneNum hasPrefix:num_ic]) {
        cutPreStr = [phoneNum substringFromIndex:[num_ic length]];
    }else {
        cutPreStr = phoneNum;
    }
    
    // 去掉可能出现的 0
    if ([cutPreStr hasPrefix:MI_CHAR_ZERO]) {
        return [cutPreStr substringFromIndex:1];
    }else {
        return cutPreStr;
    }
}

// 区域码规则
- (BOOL)matchIC:(NSString *)phoneNum
{
    if ([phoneNum hasPrefix:plus_ic]||[phoneNum hasPrefix:num_ic]) {
        return YES;
    }else {
        return NO;
    }
}

// 号码长度规则
- (BOOL)matchLEN:(NSString *)phoneNum
{
    if (_len == nil) {
        return YES;
    }else {
        for (int i=0; i<[_len count]; i++) {
            int length = [[_len objectAtIndex:i] intValue];
            if ([phoneNum length] == length) {
                return YES;
            }
        }
        return NO;
    }
}

// 号码前缀规则
- (BOOL)matchMC:(NSString *)phoneNum
{
    if (_mc == nil) {
        return YES;
    }else {
        for (int i=0; i<[_mc count]; i++) {
            if ([phoneNum hasPrefix:[_mc objectAtIndex:i]]) {
                return YES;
            }
        }
        return NO;
    }
    
}

//去除空格
- (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

//国内手机号判断
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
