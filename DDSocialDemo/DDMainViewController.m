//
//  DDMainViewController.m
//  DDSocialDemo
//
//  Created by lilingang on 16/4/5.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDMainViewController.h"
#import "DDAuthTableViewController.h"
#import "DDShareTableViewController.h"

@interface DDMainViewController ()

@end

@implementation DDMainViewController

- (IBAction)authButtonAction:(id)sender {
    DDAuthTableViewController *viewController = [[DDAuthTableViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)shareButtonAction:(id)sender {
    DDShareTableViewController *viewController = [[DDShareTableViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
