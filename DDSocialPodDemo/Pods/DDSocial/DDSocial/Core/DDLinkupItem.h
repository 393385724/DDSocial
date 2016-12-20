//
//  DDLinkupItem.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/5.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DDLinkupType) {
    DDLinkupTypeNormal,         //**< 普通公众号  */
    DDLinkupTypeDevice,         //**< 硬件公众号  */
};

@interface DDLinkupItem : NSObject

/** 跳转到该公众号的profile,公众号原始ID
 * @attention 长度不能超过512字节
 */
@property (nonatomic, copy, readonly) NSString *username;

/** 如果用户加了该公众号为好友，extMsg会上传到服务器
 * @attention 长度不能超过1024字节
 */
@property (nonatomic, copy, readonly) NSString *extMsg;

/**
 * 跳转的公众号类型
 * @see DDLinkupType
 */
@property (nonatomic, assign, readonly) DDLinkupType linkupType;

/**
 *  生成与第三方沟通的对象
 *
 *  @param userName 跳转到该公众号的profile,公众号原始ID
 *  @param extMsg   如果用户加了该公众号为好友，extMsg会上传到服务器
 *  @param type     跳转的公众号类型
 *
 *  @return DDLinkupItem对象
 */
- (instancetype)initWithUserName:(NSString *)userName
                          extMsg:(NSString *)extMsg
                            type:(DDLinkupType)type;


@end
