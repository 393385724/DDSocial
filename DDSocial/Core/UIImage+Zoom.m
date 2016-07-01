//
//  UIImage+Zoom.m
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "UIImage+Zoom.h"

@implementation UIImage (Zoom)

+ (NSData *)imageData:(NSData *)imageData maxBytes:(CGFloat)maxBytes{
    if (imageData.length < maxBytes) {
        return imageData;
    }
    //对分享的图做了一个限制，不会超过1M
    maxBytes = MIN(maxBytes, 1024*1024.0);
    CGFloat kbps = [imageData length]/maxBytes;
    if (kbps < 1.0) {
        return imageData;
    }
    UIImage *image = [UIImage imageWithData:imageData];
    CGFloat scale = sqrt(kbps);
    CGFloat newWidth = floorf(image.size.width/scale);
    CGFloat newHeight = floorf(image.size.height/scale);
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(scaledImage);
}

+ (UIImage *)imageWithImageData:(NSData *)imageData maxBytes:(CGFloat)maxBytes{
    NSData *data = [self imageData:imageData maxBytes:maxBytes];
    return [UIImage imageWithData:data];
}

@end
