//
//  DDMIRegisterCodeView.h
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/28.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDMIRegisterCodeView;

@protocol DDMIRegisterCodeViewDelegate <NSObject>
@optional
- (void)registerCodeViewDidShow:(DDMIRegisterCodeView *)view;
- (void)registerCodeViewDidDismiss:(DDMIRegisterCodeView *)view;
- (void)registerCodeView:(DDMIRegisterCodeView *)view confirmWithCode:(NSString *)code;

@end

@interface DDMIRegisterCodeView : UIView

@property (nonatomic, weak) id<DDMIRegisterCodeViewDelegate> delegate;

/**
 *  @brief 实例化一个DDMIRegisterCodeView对象
 *
 *  @return DDMIRegisterCodeView实例
 */
+ (DDMIRegisterCodeView *)registerCodeView;

/**
 *  @brief 展示错误信息
 *
 *  @param text 错误信息
 */
- (void)displayErrorText:(NSString *)text;

/**
 *  @brief 更新codeimage的图片
 *
 *  @param image 图片
 */
- (void)updateImage:(UIImage *)image;

/**
 *  @brief 展示
 */
- (void)show;

/**
 *  @brief 添加更换图片验证码方法
 *
 *  @param action SEL
 */
- (void)addTarget:(id)target changeImageAction:(SEL)action;

@end
