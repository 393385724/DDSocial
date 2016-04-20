//
//  DDAuthTableViewController.m
//  DDSocialDemo
//
//  Created by lilingang on 16/4/5.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDAuthTableViewController.h"
#import "DDSocialShareHandler.h"

@interface DDAuthTableViewController ()

@end

@implementation DDAuthTableViewController{
    NSArray *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = @[@"微信",@"小米",@"QQ",@"Sina",@"Facebook",@"Google",@"Twitter"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DDSSPlatform platform = DDSSPlatformNone;
    if (indexPath.row == 0) {
        platform = DDSSPlatformWeChat;
    } else if (indexPath.row == 1){
        platform = DDSSPlatformMI;
    } else if (indexPath.row == 2){
        platform = DDSSPlatformQQ;
    } else if (indexPath.row == 3){
        platform = DDSSPlatformSina;
    } else if (indexPath.row == 4){
        platform = DDSSPlatformFacebook;
    } else if (indexPath.row == 5){
        platform = DDSSPlatformGoogle;
    } else if (indexPath.row == 6){
        platform = DDSSPlatformTwitter;
    }
    [[DDSocialShareHandler sharedInstance] authWithPlatform:platform authMode:DDSSAuthModeToken controller:self handler:^(DDSSPlatform platform, DDSSAuthState state, DDAuthItem *authItem, NSError *error) {
        switch (state) {
            case DDSSAuthStateBegan: {
                NSLog(@"开始授权");
                break;
            }
            case DDSSAuthStateSuccess: {
                NSLog(@"授权成功：%@",authItem);
                [[DDSocialShareHandler sharedInstance] getUserInfoWithPlatform:platform authItem:authItem handler:^(DDUserInfoItem *userInfoItem, NSError *error) {
                    NSLog(@"%@,error:%@",userInfoItem,error);
                }];
                break;
            }
            case DDSSAuthStateFail: {
                NSLog(@"授权失败Error：%@",error);
                break;
            }
            case DDSSAuthStateCancel: {
                NSLog(@"授权取消");
                break;
            }
        }
    }];
}

@end
