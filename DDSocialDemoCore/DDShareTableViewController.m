//
//  DDShareTableViewController.m
//  DDSocialDemo
//
//  Created by lilingang on 16/4/5.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDShareTableViewController.h"

#import "DDSocialShareHandler.h"

@interface DDShareTableViewController ()<DDSocialShareTextProtocol,DDSocialShareImageProtocol,DDSocialShareWebPageProtocol>

@property (nonatomic, copy) NSArray *sectionArray;
@property (nonatomic, copy) NSArray *shareContentArray;

@end

@implementation DDShareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.sectionArray = @[@"微信朋友圈",@"微信好友",@"新浪",@"QQ好友",@"QQ空间",@"Facebook",@"系统Twitter",@"Twitter"];
    self.shareContentArray = @[@"纯文本",@"图片",@"网页"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionArray count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionArray[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.shareContentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.shareContentArray[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DDSSPlatform platform = [self platformWithsection:indexPath.section];
    DDSSScene shareScene = [self shareSceneWithsection:indexPath.section];
    DDSSContentType contentType = [self contentTypeWithRow:indexPath.row];
    [[DDSocialShareHandler sharedInstance] shareWithPlatform:platform controller:self shareScene:shareScene contentType:contentType protocol:self handler:^(DDSSPlatform platform, DDSSScene scene, DDSSShareState state, NSError *error) {
        switch (state) {
            case DDSSShareStateBegan: {
                NSLog(@"开始分享");
                break;
            }
            case DDSSShareStateSuccess: {
                NSLog(@"分享成功");
                break;
            }
            case DDSSShareStateFail: {
                NSLog(@"分享失败：%@",error);
                break;
            }
            case DDSSShareStateCancel: {
                NSLog(@"取消分享");
                break;
            }
        }
    }];
}



- (DDSSPlatform)platformWithsection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return DDSSPlatformWeChat;
    } else if (section == 2) {
        return DDSSPlatformSina;
    } else if (section == 3 || section == 4) {
        return DDSSPlatformQQ;
    } else if (section == 5) {
        return DDSSPlatformFacebook;
    } else if(section == 6) {
        return DDSSPlatformSystemTwitter;
    } else if(section == 7) {
        return DDSSPlatformTwitter;
    }
    return DDSSPlatformWeChat;
}

- (DDSSScene)shareSceneWithsection:(NSInteger)section{
    if (section == 0) {
        return DDSSSceneWXTimeline;
    } else if (section == 1) {
        return DDSSSceneWXSession;
    } else if (section == 2) {
        return DDSSSceneSina;
    } else if (section == 3) {
        return DDSSSceneQQFrined;
    } else if (section == 4) {
        return DDSSSceneQZone;
    } else if (section == 5) {
        return DDSSSceneFacebook;
    } else if (section == 6) {
        return DDSSSceneSystemTwitter;
    } else if (section == 7) {
        return DDSSSceneTwitter;
    } else {
        return DDSSSceneWXTimeline;
    }
}


- (DDSSContentType)contentTypeWithRow:(NSInteger)row{
    if (row == 0) {
        return DDSSContentTypeText;
    } else if (row == 1) {
        return DDSSContentTypeImage;
    } else {
        return DDSSContentTypeWebPage;
    }
}

#pragma mark - DDSocialShareTextProtocol

- (NSString *)ddShareText{
    return @"这是一条测试数据";
}

#pragma mark - DDSocialShareImageProtocol

/**
 *  @brief   标题
 */
- (NSString *)ddShareImageWithTitle{
    return @"这是标题";
}

/**
 *  @brief   图片真实数据内容
 *
 *  @note  过大的图片转换必须使用UIImagePNGRepresentation()
 *
 */
- (NSData *)ddShareImageWithImageData{
    NSString *imagPath = [[NSBundle mainBundle] pathForResource:@"IMG_5644" ofType:@"JPG"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagPath];
    return UIImagePNGRepresentation(image);
}

/**
 *  @brief   描述
 */
- (NSString *)ddShareImageWithDescription{
    return @"这是描述";
}

/**
 *  @brief  网页的URL地址
 */
- (NSString *)ddShareImageWithWebpageUrl{
    return @"http://www.huami-inc.com";
}

#pragma mark - DDSocialShareWebPageProtocol

/**
 *  @brief   标题
 */
- (NSString *)ddShareWebPageWithTitle{
    return @"web 标题";
}

/**
 *  @brief   内容描述
 */
- (NSString *)ddShareWebPageWithDescription{
    return @"web 描述";
}

/**
 *  @brief   图片真实数据
 *
 *  @note  过大的图片转换必须使用UIImagePNGRepresentation()
 *
 */
- (NSData *)ddShareWebPageWithImageData{
    NSString *imagPath = [[NSBundle mainBundle] pathForResource:@"IMG_5644" ofType:@"JPG"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagPath];
    return UIImagePNGRepresentation(image);
}

/**
 *  @brief  网页的URL地址
 */
- (NSString *)ddShareWebPageWithWebpageUrl{
    return @"http://www.huami-inc.com";
}

/**
 *  @brief   对象唯一ID，用于唯一标识一个多媒体内容
 *  @note only for sina
 */
- (NSString *)ddShareWebPageWithObjectID{
    return @"objectid";
}

@end
