//
//  DDLinkupItem.m
//  DDSocialDemo
//
//  Created by lilingang on 16/1/5.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDLinkupItem.h"

@implementation DDLinkupItem
@synthesize username = _username;
@synthesize extMsg = _extMsg;
@synthesize linkupType = _linkupType;

- (instancetype)initWithUserName:(NSString *)userName
                          extMsg:(NSString *)extMsg
                            type:(DDLinkupType)type{
    self = [super init];
    if (self) {
        _username = userName;
        _extMsg = extMsg;
        _linkupType = type;
    }
    return self;
}

@end
