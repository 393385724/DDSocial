//
//  DDMIRegisterCodeView.m
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/28.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDMIRegisterCodeView.h"
#import "DDMIDefines.h"

@interface DDMIRegisterCodeView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *codeTextFieldBackImageView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UILabel *errorTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeViewVerticalConstraint;

@end

@implementation DDMIRegisterCodeView

+ (DDMIRegisterCodeView *)registerCodeView{
    DDMIRegisterCodeView *registerCodeView = [[DDMIRegisterCodeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return registerCodeView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[UINib nibWithNibName:@"DDMIRegisterCodeView" bundle:MIResourceBundle]
                 instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        self.userInteractionEnabled = YES;
        self.codeView.layer.borderWidth = 1;
        self.codeView.layer.cornerRadius = 5;
        
        self.codeTextFieldBackImageView.layer.borderWidth = 1;
        self.codeTextFieldBackImageView.layer.borderColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1].CGColor;
        
        self.codeImageView.layer.borderWidth = 1;
        self.codeImageView.layer.borderColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1].CGColor;
        
        self.confirmButton.layer.borderWidth = 1;
        self.confirmButton.layer.cornerRadius = CGRectGetHeight(self.confirmButton.frame)/2.0;
        self.confirmButton.layer.borderColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1].CGColor;
        
        UITapGestureRecognizer *disMissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        self.contentView.userInteractionEnabled = YES;
        [self.contentView addGestureRecognizer:disMissTap];
        
        self.titleLabel.text = MILocal(@"请输入验证码");
        [self.confirmButton setTitle:MILocal(@"确定") forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark - Public Methods

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    UIView *topView = [[window subviews] objectAtIndex:0];
    topView.userInteractionEnabled = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [topView addSubview:self];
        self.alpha = 0.0;
        [UIView animateWithDuration:0.25f animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
            if (self.delegate && [self.delegate respondsToSelector:@selector(registerCodeViewDidShow:)]) {
                [self.delegate registerCodeViewDidShow:self];
            }
            [self.codeTextField becomeFirstResponder];
        }];
    });
}

- (void)displayErrorText:(NSString *)text{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.errorTipLabel.text = text;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.errorTipLabel.alpha = 1.0;
        } completion:nil];
    });
}

- (void)updateImage:(UIImage *)image{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.codeImageView.image = image;
    });
}

- (void)addTarget:(id)target changeImageAction:(SEL)action{
    UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    self.codeImageView.userInteractionEnabled = YES;
    [self.codeImageView addGestureRecognizer:imageViewTap];
}

#pragma mark - Private Methods

- (void)dismiss{
    [self.codeTextField resignFirstResponder];
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            if (self.delegate && [self.delegate respondsToSelector:@selector(registerCodeViewDidDismiss:)]) {
                [self.delegate registerCodeViewDidDismiss:self];
            }
            [self removeFromSuperview];
        }
    }];
}

- (IBAction)confirmButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(registerCodeView:confirmWithCode:)]) {
        [self.delegate registerCodeView:self confirmWithCode:self.codeTextField.text];
    }
    [self dismiss];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self confirmButtonStateChangedWithTextField:textField text:textField.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    NSString *tmpString = @"";
    if ([string length]) {//输入
        tmpString = [textField.text stringByAppendingString:string];
    }else {//删除
        tmpString = [textField.text substringToIndex:[textField.text length] > 0 ? [textField.text length] - 1 : 0];
    }
    [self confirmButtonStateChangedWithTextField:textField text:tmpString];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.codeTextField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self confirmButtonStateChangedWithTextField:textField text:nil];
    return YES;
}

- (void)confirmButtonStateChangedWithTextField:(UITextField *)textField text:(NSString *)text{
    self.errorTipLabel.alpha = 0.0;
    if ([text length]) {
        self.confirmButton.enabled = YES;
    } else {
        self.confirmButton.enabled = NO;
    }
}

#pragma mark - Notification

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification{
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = CGRectGetMinY(keyboardRect);
    __block CGFloat verticalOffset = -20.0;
    CGFloat defaultCodeViewMinY = (CGRectGetHeight(self.frame) - CGRectGetHeight(self.codeView.frame))/2.0 + verticalOffset;
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGFloat height = CGRectGetHeight(self.frame);
                         if (keyboardY == height) {
                             self.codeView.frame = CGRectMake(CGRectGetMinX(self.codeView.frame), defaultCodeViewMinY, CGRectGetWidth(self.codeView.frame), CGRectGetHeight(self.codeView.frame));
                         } else {
                             CGFloat offset = keyboardY - CGRectGetMaxY(self.codeView.frame);
                             if (offset < 0) {
                                 verticalOffset += offset;
                                 self.codeView.frame = CGRectMake(CGRectGetMinX(self.codeView.frame), defaultCodeViewMinY + offset, CGRectGetWidth(self.codeView.frame), CGRectGetHeight(self.codeView.frame));
                             }
                         }
                     } completion:nil];
    self.codeViewVerticalConstraint.constant = verticalOffset;
}

@end
