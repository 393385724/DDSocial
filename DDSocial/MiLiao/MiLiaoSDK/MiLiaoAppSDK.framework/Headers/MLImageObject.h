//
//  MLImageObject.h
//  MiLiaoAppSDK
//
//  Created by zhang weiliang on 13-4-18.
//  Copyright (c) 2013年 zhang weiliang. All rights reserved.
//

#define MIMETYPE_JPEG   @"image/jpg"
#define MIMETYPE_PNG    @"image/png"
#define MIMETYPE_GIF    @"image/gif"

@interface MLImageObject : NSObject

/*
 * imageData 图片的真实数据，大小不能超过200k，只支持上面三种类型jpg和png和gif
 */
@property (nonatomic, strong) NSData *imageData;

/*
 * imageUrl 图片的外部链接，大小不能超过10k
 */
@property (nonatomic, strong) NSString *imageUrl;

/*
 * mimeType 图片的格式，支持三种，见上面的宏定义
 */
@property (nonatomic, strong) NSString *mimeType;

+ (MLImageObject *)imageObject;

/*
 * 通过下面的方法可以方便的设置imageData的数据
 */
- (void)setImage:(UIImage *)image;

@end
