//
//  DDUserInfoItem.m
//  DDSocialCodeDemo
//
//  Created by lilingang on 16/4/19.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDUserInfoItem.h"

@implementation DDUserInfoItem
@synthesize platform = _platform;
@synthesize nickName = _nickName;
@synthesize desString = _desString;
@synthesize genderType = _genderType;
@synthesize avatarURL = _avatarURL;
@synthesize rawObject =_rawObject;

- (instancetype)initWithPlatForm:(DDSSPlatform)platForm rawObject:(id)rawObject{
    self = [super init];
    if (self) {
        _platform = platForm;
        _rawObject = rawObject;
        _genderType = DDSSGenderTypeUnkown;
        if (platForm == DDSSPlatformQQ) {
            [self setupTencentUserInfoDict:rawObject];
        } else if (platForm == DDSSPlatformMI) {
            [self setupMIUserInfoDict:rawObject];
        } else if (platForm == DDSSPlatformSina) {
            [self setupSinaUserInfoDict:rawObject];
        } else if (platForm == DDSSPlatformWeChat) {
            [self setupWeChatUserInfoDict:rawObject];
        }
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupWeChatUserInfoDict:(NSDictionary *)infoDict{
    _nickName = [infoDict objectForKey:@"nickname"];
    NSInteger sex = [[infoDict objectForKey:@"sex"] integerValue];
    if (sex == 1) {
        _genderType = DDSSGenderTypeMale;
    } else {
        _genderType = DDSSGenderTypeFemale;
    }
    _avatarURL = [infoDict objectForKey:@"headimgurl"];
}

- (void)setupMIUserInfoDict:(NSDictionary *)infoDict{
    _nickName = [infoDict objectForKey:@"miliaoNick"];
    _avatarURL = [infoDict objectForKey:@"miliaoIcon_orig"];
    if (!_avatarURL) {
        _avatarURL = [infoDict objectForKey:@"miliaoIcon_320"];
    }
    if (!_avatarURL) {
        _avatarURL = [infoDict objectForKey:@"miliaoIcon"];
    }
}

- (void)setupSinaUserInfoDict:(NSDictionary *)infoDict{
    _nickName = [infoDict objectForKey:@"screen_name"];
    _desString = [infoDict objectForKey:@"description"];
    NSString *genderString = [infoDict objectForKey:@"gender"];
    if ([genderString isEqualToString:@"m"]) {
        _genderType = DDSSGenderTypeMale;
    } else if ([genderString isEqualToString:@"f"]) {
        _genderType = DDSSGenderTypeFemale;
    }
    _avatarURL = [infoDict objectForKey:@"avatar_large"];
    if ([infoDict objectForKey:@"avatar_hd"]) {
        _avatarURL = [infoDict objectForKey:@"avatar_hd"];
    }
}

- (void)setupTencentUserInfoDict:(NSDictionary *)infoDict{
    _nickName = [infoDict objectForKey:@"nickname"];
    NSString *genderString = [infoDict objectForKey:@"gender"];
    _genderType = DDSSGenderTypeMale;
    if ([genderString isEqualToString:@"女"]) {
        _genderType = DDSSGenderTypeFemale;
    }
    
    /**大小为100×100像素的QQ头像URL。需要注意，不是所有的用户都拥有QQ的100x100 figureurl_qq_2的头像，但figureurl_qq_1 40x40像素则是一定会有*/
    _avatarURL = [infoDict objectForKey:@"figureurl_qq_1"];
    if ([infoDict objectForKey:@"figureurl_qq_2"]) {
        _avatarURL = [infoDict objectForKey:@"figureurl_qq_2"];
    }
}

- (void)setupFacebookUserInfoDict:(NSDictionary *)infoDict{
    _nickName = [infoDict objectForKey:@"name"];
    NSString *genderString = [infoDict objectForKey:@"gender"];
    _genderType = DDSSGenderTypeMale;
    if ([genderString isEqualToString:@"female"]) {
        _genderType = DDSSGenderTypeFemale;
    }
    /**大小为100×100像素的QQ头像URL。需要注意，不是所有的用户都拥有QQ的100x100 figureurl_qq_2的头像，但figureurl_qq_1 40x40像素则是一定会有*/
    _avatarURL = [[[infoDict objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"nickName:%@\ndesString:%@\nrawObject:%@",self.nickName,self.desString,self.rawObject];
}
@end
