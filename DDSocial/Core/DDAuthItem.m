//
//  DDAuthItem.m
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDAuthItem.h"

@implementation DDAuthItem

- (NSString *)description{
    return  [NSString stringWithFormat:@"thirdToken:%@\nthirdId:%@\nrawObject:%@",self.thirdToken,self.thirdId,self.rawObject];
}

@end
