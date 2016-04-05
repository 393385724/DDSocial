//
//  DDAuthTableViewController.m
//  DDSocialDemo
//
//  Created by lilingang on 16/4/5.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDAuthTableViewController.h"
#import "DDSocialAuthHandler.h"

@interface DDAuthTableViewController ()

@end

@implementation DDAuthTableViewController{
    NSArray *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = @[@"微信",@"小米",@"Facebook"];
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
        platform = DDSSPlatformFacebook;
    }
    [[DDSocialAuthHandler sharedInstance] authWithPlatform:platform controller:self authHandler:^(DDSSPlatform platform, DDSSAuthState state, id result, NSError *error) {
        switch (state) {
            case DDSSAuthStateBegan: {
                NSLog(@"开始授权");
                break;
            }
            case DDSSAuthStateSuccess: {
                NSLog(@"授权成功:%@",result);
                break;
            }
            case DDSSAuthStateFail: {
                NSLog(@"授权失败:%@",error);
                break;
            }
            case DDSSAuthStateCancel: {
                NSLog(@"取消授权");
                break;
            }
        }
    }];
}

@end
