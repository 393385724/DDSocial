//
//  DDMILoginViewController.h
//  HMLoginDemo
//
//  Created by lilingang on 15/8/4.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import "DDMIBaseViewController.h"
#import "DDMIRequestHandle.h"


typedef NS_ENUM(NSUInteger, DDMILoginType) {
    DDMILoginTypeDefault,
    DDMILoginTypeImageVerification,
};

@class DDMILoginViewController;

@protocol DDMILoginViewControllerDelegate <NSObject>

- (void)loginViewController:(DDMILoginViewController *)viewController
    successNeedDaynamicCode:(BOOL)needDaynamicCode;

@end

@interface DDMILoginViewController : DDMIBaseViewController<DDMIRequestHandleDelegate>

@property (nonatomic, weak) id<DDMILoginViewControllerDelegate> delegate;

- (instancetype)initWithRequestHandle:(DDMIRequestHandle *)requestHandle;

@end
