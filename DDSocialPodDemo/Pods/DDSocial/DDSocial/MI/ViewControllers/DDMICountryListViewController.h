//
//  DDMICountryListViewController.h
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/29.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDMIBaseViewController.h"

@protocol DDMICountryListViewControllerDelegate <NSObject>

- (void)countryListViewControllerDidSelectedCountryName:(NSString *)name code:(NSString *)code;

@end

@interface DDMICountryListViewController : DDMIBaseViewController

@property (nonatomic, weak) id <DDMICountryListViewControllerDelegate> delegate;

@end
