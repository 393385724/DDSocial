//
//  DDMIAgreementAndPolicyViewController.m
//  midong
//
//  Created by lilingang on 16/4/23.
//  Copyright © 2016年 HM IOS Team. All rights reserved.
//

#import "DDMIAgreementAndPolicyViewController.h"

@implementation DDMIAgreementAndPolicyViewController{
    NSString *_loadDefaultHTML;
}

- (instancetype)initWithTitle:(NSString *)title loadHTML:(NSString *)defaultHTML{
    self = [super init];
    if (self) {
        self.title = title;
        _loadDefaultHTML = defaultHTML;
    }
    return self;
}

#pragma mark - Template Methods

- (NSString *)loadWholeURLString{
    return _loadDefaultHTML;
}

@end
