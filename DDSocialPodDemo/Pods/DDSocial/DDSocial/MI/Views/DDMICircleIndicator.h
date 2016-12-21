//
//  DDMICircleIndicator.h
//  HMLoginDemo
//
//  Created by lilingang on 15/8/5.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMICircleIndicator : UIView

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName;

- (void)startAnimation;
- (void)stopAnimation;

@end
