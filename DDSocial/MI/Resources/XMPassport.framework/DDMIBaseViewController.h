//
//  DDMIBaseViewController.h
//  HMLoginDemo
//
//  Created by lilingang on 15/8/5.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMIDefines.h"
#import "DDMITypeDefines.h"

@protocol DDMICancelDelegate <NSObject>

- (void)viewControllerCanceled:(UIViewController *)viewController;

@end

@interface DDMIBaseViewController : UIViewController

@property (nonatomic, weak) id<DDMICancelDelegate> cancelDelegate;

@end
