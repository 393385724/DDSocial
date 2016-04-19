//
//  DDMICircleIndicator.m
//  HMLoginDemo
//
//  Created by lilingang on 15/8/5.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import "DDMICircleIndicator.h"
#import "DDMIDefines.h"

@interface DDMICircleIndicator ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation DDMICircleIndicator

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSettingsWithImagename:@"dd_circleIndicator_icon"];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame imageName:@"dd_circleIndicator_icon"];
}

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSettingsWithImagename:imageName];
    }
    return self;
}

- (void)initSettingsWithImagename:(NSString *)imageName{
    self.backgroundColor = [UIColor clearColor];
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.imageView.image = MIImage(imageName);
    [self addSubview:self.imageView];
}

- (void)startAnimation{
    if (![NSThread isMainThread]) {
        NSLog(@"current animation is not running on main thread!!");
    }
    self.hidden = NO;
    self.isAnimating = YES;
    [self.layer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(2*M_PI);
    animation.duration = 1.f;
    animation.repeatCount = INT_MAX;
    [self.layer addAnimation:animation forKey:@"keyFrameAnimation"];
}

- (void)stopAnimation{
    if (![NSThread isMainThread]) {
        NSLog(@"current animation is not running on main thread!!");
    }
    
    self.hidden = YES;
    self.isAnimating = NO;
    [self.layer removeAllAnimations];
}
@end
