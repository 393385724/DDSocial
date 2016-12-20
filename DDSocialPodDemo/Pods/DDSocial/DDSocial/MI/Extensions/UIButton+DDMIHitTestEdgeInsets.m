//
//  UIButton+DDMIHitTestEdgeInsets.m
//  HMLoginDemo
//
//  Created by lilingang on 15/8/6.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import "UIButton+DDMIHitTestEdgeInsets.h"
#import <objc/runtime.h>

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"DDMIHitTestEdgeInsets";

@implementation UIButton (DDMIHitTestEdgeInsets)

-(void)setMiHitTestEdgeInsets:(UIEdgeInsets)miHitTestEdgeInsets {
    NSValue *value = [NSValue value:&miHitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)miHitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets;
        [value getValue:&edgeInsets];
        return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.miHitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.miHitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

@end
