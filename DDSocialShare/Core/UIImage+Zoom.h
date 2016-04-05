//
//  UIImage+Zoom.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Zoom)

+ (NSData *)imageData:(NSData *)imageData maxBytes:(CGFloat)maxBytes;

+ (UIImage *)imageWithImageData:(NSData *)imageData maxBytes:(CGFloat)maxBytes;

@end
