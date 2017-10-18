//
//  DDInstagramHandler.m
//  DDSocialCodeDemo
//
//  Created by 李林刚 on 2017/10/18.
//  Copyright © 2017年 LiLingang. All rights reserved.
//
//https://www.instagram.com/developer/mobile-sharing/iphone-hooks/

#import "DDInstagramHandler.h"
#import <UIKit/UIKit.h>
#import "DDSocialShareContentProtocol.h"

@interface DDInstagramHandler ()<UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
/*分享*/
@property (nonatomic, assign) DDSSScene shareScene;
@property (nonatomic, copy) DDSSShareEventHandler shareEventHandler;

@end

@implementation DDInstagramHandler


- (BOOL)shareImageWithProtocol:(id<DDSocialShareImageProtocol>)protocol{
    NSData *imageData = [protocol ddShareImageWithImageData];
    if (!imageData) {
        if (self.shareEventHandler) {
            self.shareEventHandler(DDSSPlatformInstagram, self.shareScene, DDSSShareStateBegan, nil);
            NSError *error = [NSError errorWithDomain:@"DDSocialShare Domain" code:404 userInfo:@{NSLocalizedDescriptionKey:@"image is nil"}];
            self.shareEventHandler(DDSSPlatformInstagram, self.shareScene, DDSSShareStateFail, error);
            self.shareEventHandler = nil;
        }
        return NO;
    }
    if (![[self class] isInstalled]) {
        return NO;
    }
    UIImage *image = [UIImage imageWithData:imageData];
    CGFloat cropVal = (image.size.height > image.size.width ? image.size.width : image.size.height);
    cropVal *= [UIScreen mainScreen].scale;
    CGRect cropRect = (CGRect){.size.height = cropVal, .size.width = cropVal};
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    NSData *jpegImageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 1.0);
    CGImageRelease(imageRef);
    NSString *saveImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
    if (![jpegImageData writeToFile:saveImagePath atomically:YES]) {
        NSLog(@"image save failed to path %@", saveImagePath);
        return NO;
    }
    NSURL *imageURL=[NSURL fileURLWithPath:saveImagePath];
    
    UIDocumentInteractionController *documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:imageURL];
    documentInteractionController.delegate = self;
    documentInteractionController.annotation = @{@"InstagramCaption" : @"We are making fun"};
    documentInteractionController.UTI = @"com.instagram.exclusivegram";
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 320, 320) inView:vc.view animated:YES];
    self.documentInteractionController = documentInteractionController;
    return YES;
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller {
    if (self.shareEventHandler) {
        self.shareEventHandler(DDSSPlatformInstagram, self.shareScene, DDSSShareStateBegan, nil);
    }
}
- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    if (self.shareEventHandler) {
        self.shareEventHandler(DDSSPlatformInstagram, self.shareScene, DDSSShareStateSuccess, nil);
        self.shareEventHandler = nil;
    }
}

@end

@implementation DDInstagramHandler (DDSocialHandlerProtocol)

+ (BOOL)isInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://app"]];
}

- (BOOL)shareWithController:(UIViewController *)viewController
                 shareScene:(DDSSScene)shareScene
                contentType:(DDSSContentType)contentType
                   protocol:(id<DDSocialShareContentProtocol>)protocol
                    handler:(DDSSShareEventHandler)handler {
    if (!handler) {
        return NO;
    }
    self.shareScene = shareScene;
    self.shareEventHandler = handler;
    BOOL openSuccess = NO;
    if (contentType == DDSSContentTypeImage && [protocol conformsToProtocol:@protocol(DDSocialShareImageProtocol)]) {
        openSuccess = [self shareImageWithProtocol:(id<DDSocialShareImageProtocol>)protocol];
    } else {
        if (self.shareEventHandler) {
            self.shareEventHandler(DDSSPlatformInstagram, self.shareScene, DDSSShareStateBegan, nil);

            NSString *errorDescription = [NSString stringWithFormat:@"not suport share format error:%@ shareType:%lu",NSStringFromClass([protocol class]),(unsigned long)contentType];
            NSError *error = [NSError errorWithDomain:@"Instagram Local Share Error" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
            self.shareEventHandler(DDSSPlatformInstagram, self.shareScene, DDSSShareStateFail, error);
            self.shareEventHandler = nil;
        }
        return NO;
    }
    return openSuccess;
}

@end

