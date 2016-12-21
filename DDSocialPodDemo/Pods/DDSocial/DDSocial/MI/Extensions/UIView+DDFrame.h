//
//  UIView+DDFrame.h
//  HMLoginDemo
//
//  Created by lilingang on 15/8/4.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DDFrame)

@property (nonatomic, readwrite) CGFloat ddTop;
@property (nonatomic, readwrite) CGFloat ddBottom;
@property (nonatomic, readwrite) CGFloat ddLeft;
@property (nonatomic, readwrite) CGFloat ddRight;
@property (nonatomic, readwrite) CGFloat ddMiddleX;
@property (nonatomic, readwrite) CGFloat ddMiddleY;
@property (nonatomic, readwrite) CGFloat ddWidth;
@property (nonatomic, readwrite) CGFloat ddHeight;
@property (nonatomic, readwrite) CGPoint ddLeftTopPoint;

@property (nonatomic, readonly) CGSize ddSize;
@property (nonatomic, readonly) CGPoint ddBoundsCenter;

@end
