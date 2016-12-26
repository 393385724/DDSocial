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
    _dataSource = @[@"微信",@"小米",@"QQ",@"Sina",@"Facebook",@"Google"];
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
    } else if (indexPath.row == 1) {
        platform = DDSSPlatformMI;
    } else if (indexPath.row == 2) {
        platform = DDSSPlatformQQ;
    } else if (indexPath.row == 3) {
        platform = DDSSPlatformSina;
    } else if (indexPath.row == 4) {
        platform = DDSSPlatformFacebook;
    } else if (indexPath.row == 5) {
        platform = DDSSPlatformGoogle;
    }
    [[DDSocialShareHandler sharedInstance] authWithPlatform:platform authMode:DDSSAuthModeToken controller:self handler:^(DDSSPlatform platform, DDSSAuthState state, DDAuthItem *authItem, NSError *error) {
        switch (state) {
            case DDSSAuthStateBegan: {
                NSLog(@"开始授权");
                break;
            }
            case DDSSAuthStateSuccess: {
                NSLog(@"授权成功：%@",authItem);
                [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", authItem] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                [[DDSocialShareHandler sharedInstance] getUserInfoWithPlatform:platform authItem:authItem handler:^(DDUserInfoItem *userInfoItem, NSError *error) {
                    if (error) {
                        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"error:%@", error] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                    } else {
                        if (userInfoItem) {
                            [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", userInfoItem] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                        }
                    }
                }];
                break;
            }
            case DDSSAuthStateFail: {
                [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"授权失败Error:%@", error] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
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
