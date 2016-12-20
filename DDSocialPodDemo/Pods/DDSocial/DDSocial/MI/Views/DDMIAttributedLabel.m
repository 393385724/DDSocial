//
//  DDMIAttributedLabel.m
//  midong
//
//  Created by lilingang on 16/4/23.
//  Copyright © 2016年 HM IOS Team. All rights reserved.
//

#import "DDMIAttributedLabel.h"

@implementation DDMIAttributedLabel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSettings];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSettings];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSettings];
}

- (void)initSettings{
//    UIColor *linkColor = [UIColor colorWithRed:36 green:153 blue:194 alpha:1.0];
//    NSMutableDictionary *linkAttributesDict = [[NSMutableDictionary alloc] init];
//    [linkAttributesDict setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
//    [linkAttributesDict setObject:(id)[linkColor CGColor] forKey:(NSString *)kCTUnderlineColorAttributeName];
//    [linkAttributesDict setObject:(id)[linkColor CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    self.linkAttributes = nil;
    self.activeLinkAttributes = nil;
}

@end
