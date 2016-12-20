//
//  DDMIBaseViewController.m
//  HMLoginDemo
//
//  Created by lilingang on 15/8/5.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import "DDMIBaseViewController.h"

@interface DDMIBaseViewController ()

@end

@implementation DDMIBaseViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    UIView *customLedfNavigationBarView = nil;
    if ([self leftBarAction] == DDMINavigationLeftBarActionCancel) {
        UIButton* cancelButton= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [cancelButton setTitle:MILocal(@"取消") forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        customLedfNavigationBarView = cancelButton;
    } else {
        UIButton* backButton= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [backButton setImage:MIImage(@"dd_mi_back_normal") forState:UIControlStateNormal];
        [backButton setImage:MIImage(@"dd_mi_back_highlight") forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        customLedfNavigationBarView = backButton;
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:customLedfNavigationBarView];
    UIBarButtonItem *fixedSpaceItem = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    fixedSpaceItem.width = -15;
    self.navigationItem.leftBarButtonItems = @[fixedSpaceItem,backItem];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
#pragma clang diagnostic pop
}

#pragma mark - Template Methods

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (DDMINavigationLeftBarAction)leftBarAction{
    return DDMINavigationLeftBarActionCancel;
}

- (void)cancelButtonAction:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:DDMILoginCancelNotification object:nil];
}

- (void)backButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
