//
//  DDMIBaseViewController.h
//  HMLoginDemo
//
//  Created by lilingang on 15/8/5.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMIDefines.h"

typedef NS_ENUM(NSUInteger, DDMINavigationLeftBarAction) {
    DDMINavigationLeftBarActionCancel,   //**展示取消触发dismiss*/
    DDMINavigationLeftBarActionBack,     //**展示<触发pop*/
};

/**
 *  @brief 小米登录所有页面的根类
 */
@interface DDMIBaseViewController : UIViewController

/**
 *  @brief 返回Navigation Left Bar 展现以及事件, 默认DDMINavigationLeftBarActionCancel
 *
 *  @return DDMINavigationLeftBarAction
 */
- (DDMINavigationLeftBarAction)leftBarAction;

/**
 *  @brief 取消按钮点击出发的时间
 *
 *  @param sender UIButton
 */
- (void)cancelButtonAction:(id)sender;

/**
 *  @brief 返回按钮点击出发的时间
 *
 *  @param sender UIButton
 */
- (void)backButtonAction:(id)sender;

@end
