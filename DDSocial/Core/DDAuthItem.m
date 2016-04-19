//
//  DDAuthItem.m
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDAuthItem.h"

@implementation DDAuthItem

- (instancetype)init{
    self = [super init];
    if (self) {
        self.isCodeAuth = YES;
    }
    return self;
}

- (NSString *)description{
    return  [NSString stringWithFormat:@"thirdToken:%@\nthirdId:%@\nisCodeAuth:%@\n%@\n",self.thirdToken,self.thirdId,self.isCodeAuth ? @"YES":@"NO",self.userInfo];
}

@end
