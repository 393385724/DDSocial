//
//  UIImage+Zoom.m
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "UIImage+Zoom.h"
#import <Accelerate/Accelerate.h>

static int16_t unsharpen_kernel[9] = {
    -1, -1, -1,
    -1, 17, -1,
    -1, -1, -1
};

@implementation UIImage (Zoom)

+ (NSData *)imageData:(NSData *)imageData maxBytes:(CGFloat)maxBytes type:(DDSocialImageType)type{
    CGFloat maxWidth = 0.0;
    if (type == DDSocialImageTypeOrigin) {
        //对分享的图做了一个限制，不会超过1M
        maxBytes = MIN(maxBytes, 1024*1024.0);
        maxWidth = 1024;
    } else {
        //对分享的图做了一个限制，缩略图不会超过32k
        maxBytes = MIN(maxBytes, 32*1024.0);
        maxWidth = 180;
    }
    if ([imageData length] < maxBytes) {
        //图像没有超限则直接返回
        return imageData;
    }
    UIImage *originImage = [UIImage imageWithData:imageData];
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (originImage.size.width > originImage.size.height) {
        btWidth = maxWidth;
        btHeight = originImage.size.height * (maxWidth / originImage.size.width);
    } else {
        btHeight = maxWidth;
        btWidth = originImage.size.width * (maxWidth / originImage.size.height);
    }
    UIGraphicsBeginImageContext(CGSizeMake(btWidth, btHeight));
    [originImage drawInRect:CGRectMake(0, 0, btWidth,btHeight)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *newImageData = UIImageJPEGRepresentation([scaledImage unsharpen], 1.0);
    CGFloat compressionQuality = 1.0;
    while ([newImageData length] > maxBytes) {
        @autoreleasepool {
            compressionQuality -= 0.2;
            newImageData = UIImageJPEGRepresentation(scaledImage, compressionQuality);
        }
        if (compressionQuality < 0.6) {
            NSLog(@"图片太大无法完成分享，缩略图不应超过32k 原始图不应超过1M");
            break;
        }
    }
    return newImageData;
}

+ (UIImage *)imageWithImageData:(NSData *)imageData maxBytes:(CGFloat)maxBytes type:(DDSocialImageType)type{
    NSData *data = [self imageData:imageData maxBytes:maxBytes type:type];
    return [UIImage imageWithData:data];
}

#pragma mark - Private Methods

+ (NSData *)imageData:(NSData *)imageData compressionQuality:(CGFloat)compressionQuality{
    UIImage *image = [UIImage imageWithData:imageData];
    return UIImageJPEGRepresentation(image, compressionQuality);
}

- (UIImage *)unsharpen{
    const size_t width = self.size.width;
    const size_t height = self.size.height;
    const size_t bytesPerRow = width * 4;
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(space);
    if (!bmContext)
        return nil;
    
    CGContextDrawImage(bmContext, (CGRect) {.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.CGImage);
    
    UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data)
    {
        CGContextRelease(bmContext);
        return nil;
    }
    
    const size_t n = sizeof(UInt8) * width * height * 4;
    void* outt = malloc(n);
    vImage_Buffer src = {data, height, width, bytesPerRow};
    vImage_Buffer dest = {outt, height, width, bytesPerRow};
    vImageConvolve_ARGB8888(&src, &dest, NULL, 0, 0, unsharpen_kernel, 3, 3, 9, NULL, kvImageCopyInPlace);
    
    memcpy(data, outt, n);
    
    free(outt);
    
    CGImageRef unsharpenedImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* unsharpened = [UIImage imageWithCGImage:unsharpenedImageRef];
    
    CGImageRelease(unsharpenedImageRef);
    CGContextRelease(bmContext);
    
    return unsharpened;
}

@end
