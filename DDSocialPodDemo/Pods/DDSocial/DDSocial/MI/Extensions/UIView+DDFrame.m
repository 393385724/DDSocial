//
//  UIView+DDFrame.m
//  HMLoginDemo
//
//  Created by lilingang on 15/8/4.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import "UIView+DDFrame.h"

@implementation UIView (DDFrame)

- (void)setDdTop:(CGFloat)ddTop{
    self.frame = CGRectMake(self.ddLeft, ddTop, self.ddWidth, self.ddHeight);
}
- (CGFloat)ddTop {
    return self.frame.origin.y;
}
- (void)setDdBottom:(CGFloat)ddBottom {
    self.frame = CGRectMake(self.ddLeft,ddBottom-self.ddHeight,self.ddWidth,self.ddHeight);
}
- (CGFloat)ddBottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setDdLeft:(CGFloat)ddLeft {
    self.frame = CGRectMake(ddLeft,self.ddTop,self.ddWidth,self.ddHeight);
}
- (CGFloat)ddLeft {
    return self.frame.origin.x;
}
- (void)setDdRight:(CGFloat)ddRight {
    self.frame = CGRectMake(ddRight-self.ddWidth,self.ddTop,self.ddWidth,self.ddHeight);
}
- (CGFloat)ddRight {
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setDdMiddleX:(CGFloat)ddMiddleX {
    self.frame = (CGRectMake(ddMiddleX - self.ddWidth / 2, self.ddTop, self.ddWidth, self.ddHeight));
}
- (CGFloat)ddMiddleX {
    return self.frame.origin.x + roundf(self.frame.size.width / 2);
}
- (void)setDdMiddleY:(CGFloat)ddMiddleY {
    self.frame = (CGRectMake(self.ddLeft, ddMiddleY - self.ddHeight / 2, self.ddWidth, self.ddHeight));
}
- (CGFloat)ddMiddleY {
    return self.frame.origin.y + roundf(self.frame.size.height / 2);
}
- (void)setDdWidth:(CGFloat)ddWidth {
    self.frame = (CGRectMake(self.ddLeft, self.ddTop, ddWidth, self.ddHeight));
}
- (CGFloat)ddWidth {
    return self.frame.size.width;
}
- (void)setDdHeight:(CGFloat)ddHeight {
    self.frame = CGRectMake(self.ddLeft, self.ddTop, self.ddWidth, ddHeight);
}
- (CGFloat)ddHeight {
    return self.frame.size.height;
}

- (CGSize)ddSize{
    return CGSizeMake(self.ddWidth, self.ddHeight);
}

- (CGPoint)ddBoundsCenter {
    return CGPointMake(roundf(self.ddWidth / 2.0), roundf(self.ddHeight / 2.0));
}
- (void)setDdLeftTopPoint:(CGPoint)ddLeftTopPoint {
    self.frame = CGRectMake(ddLeftTopPoint.x, ddLeftTopPoint.y, self.ddWidth, self.ddHeight);
}
- (CGPoint)ddLeftTopPoint {
    return CGPointMake(self.frame.origin.x, self.frame.origin.y);
}


@end
