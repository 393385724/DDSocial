//
//  NSString+DDMI.m
//  DDSocialCodeDemo
//
//  Created by lilingang on 16/6/27.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "NSString+DDMI.h"
#import "DDMIDefines.h"

@implementation NSString (DDMI)

+ (NSString *)imageFilePathWithImageName:(NSString *)imageName{
    NSString *imagefilePath = [MIResourceBundlePath stringByAppendingPathComponent:imageName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagefilePath]) {
        return imagefilePath;
    }
    NSArray *imageNameSuffixArray = @[@".png",@".jpg",@"@2x.png",@"@2x.jpg",@"@3x.png",@"@3x.jpg"];
    for (NSString *suffix in imageNameSuffixArray) {
        NSString *newImageName = [imageName stringByAppendingString:suffix];
        imagefilePath = [MIResourceBundlePath stringByAppendingPathComponent:newImageName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imagefilePath]) {
            break;
        }
    }
    return imagefilePath;
}

@end
