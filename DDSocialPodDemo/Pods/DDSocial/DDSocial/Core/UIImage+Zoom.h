//
//  UIImage+Zoom.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDSocialImageType) {
    DDSocialImageTypeThumbnail,  //**缩略图*/
    DDSocialImageTypeOrigin,     //**原始图*/
};

@interface UIImage (Zoom)

+ (NSData *)imageData:(NSData *)imageData maxBytes:(CGFloat)maxBytes type:(DDSocialImageType)type;

+ (UIImage *)imageWithImageData:(NSData *)imageData maxBytes:(CGFloat)maxBytes type:(DDSocialImageType)type;

@end
