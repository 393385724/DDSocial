//
//  DDMIVerifyLoginViewController.m
//  HMLoginDemo
//
//  Created by lilingang on 15/8/5.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import "DDMIVerifyLoginViewController.h"
#import "DDMICircleIndicator.h"

#import "DDMIRequestHandle.h"

@interface DDMIVerifyLoginViewController ()<UITextFieldDelegate,DDMIRequestHandleDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *inputBackImageView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *trustLabel;
@property (weak, nonatomic) IBOutlet UIButton *trustButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *errorTipLabel;
@property (weak, nonatomic) IBOutlet DDMICircleIndicator *indicatorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTopConstraint;


@property (nonatomic, assign) BOOL isTrustDevice;//是否是可信任的设备

@property (nonatomic, strong) DDMIRequestHandle *requestHandle;

@end

@implementation DDMIVerifyLoginViewController

- (instancetype)initWithRequestHandle:(DDMIRequestHandle *)requestHandle{
    self = [super initWithNibName:@"DDMIVerifyLoginViewController" bundle:MIResourceBundle];
    if (self) {
        self.requestHandle = requestHandle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = MILocal(@"口令验证");

    self.confirmButton.enabled = NO;
    self.confirmButton.layer.borderWidth = 1;
    self.confirmButton.layer.cornerRadius = CGRectGetHeight(self.confirmButton.frame)/2.0;
    self.confirmButton.layer.borderColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1].CGColor;
    [self.confirmButton setBackgroundColor:[UIColor colorWithRed:252/255.0f green:252/255.0f blue:252/255.0f alpha:1]];
    [self.confirmButton setTitle:MILocal(@"确定") forState:UIControlStateNormal];
    
    //隐藏键盘
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.inputBackImageView.image = MIImage(@"dd_mi_single_input_bg");
    
    self.tipLabel.text = MILocal(@"一个账号,玩转所有小米服务!");
    self.codeTextField.placeholder = MILocal(@"请输入6位动态口令");
    self.trustLabel.text = MILocal(@"这是我的私人设备,以后登录无需输入口令");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.requestHandle.delegate = self;
    [self hidenKeyboard:nil];
}

#pragma mark - Template Methods

- (DDMINavigationLeftBarAction)leftBarAction{
    return DDMINavigationLeftBarActionBack;
}

#pragma mark - Button actions
- (void)backButtonAction:(id)sender{
    self.requestHandle.delegate = [self.navigationController.viewControllers firstObject];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)trustButtonAction:(id)sender {
    self.isTrustDevice = !self.isTrustDevice;
    NSString *imageName = self.isTrustDevice ? @"dd_mi_button_trust_icon" : @"dd_mi_button_untrust_icon";
    [self.trustButton setImage:MIImage(imageName) forState:UIControlStateNormal];
}

- (IBAction)confirmButtonAction:(id)sender {
    [self.indicatorView startAnimation];
    self.confirmButton.enabled = NO;
    self.view.userInteractionEnabled = NO;
    [self.requestHandle checkOTPCode:self.codeTextField.text trustDevice:self.isTrustDevice];
}

#pragma mark -  DDMIRequestHandleDelegate

- (void)requestHandleDidSuccess:(DDMIRequestHandle *)requestHandle{
    [self.indicatorView stopAnimation];
    self.confirmButton.enabled = YES;
    self.view.userInteractionEnabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:DDMILoginAuthNotification object:nil];
}

- (void)requestHandle:(DDMIRequestHandle *)requestHandle failedWithType:(DDMIErrorType)errorType errorMessage:(NSString *)errorMessage error:(NSError *)error{
    [self.indicatorView stopAnimation];
    self.confirmButton.enabled = YES;
    self.view.userInteractionEnabled = YES;
    [self displayErrorTipLabelWithText:errorMessage];
}

- (void)displayErrorTipLabelWithText:(NSString *)text{
    self.errorTipLabel.text = text;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.errorTipLabel.alpha = 1.0;
    } completion:nil];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self confirmButtonStateChangedWithText:textField.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    NSString *tmpString = @"";
    if ([string length]) {//输入
        tmpString = [textField.text stringByAppendingString:string];
    }
    else {//删除
        tmpString = [textField.text substringToIndex:[textField.text length] > 0 ? [textField.text length] - 1 : 0];
    }
    [self confirmButtonStateChangedWithText:tmpString];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [self.codeTextField resignFirstResponder];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self confirmButtonStateChangedWithText:nil];
    return YES;
}

- (void)confirmButtonStateChangedWithText:(NSString *)text{
    self.errorTipLabel.alpha = 0.0;
    if ([text length]) {
        self.confirmButton.enabled = YES;
    }
    else {
        self.confirmButton.enabled = NO;
    }
}


#pragma mark - Keyboard

- (void)hidenKeyboard:(UIGestureRecognizer *)recognizer{
    if ([self.codeTextField isFirstResponder]) {
        [self.codeTextField resignFirstResponder];
    }
}

#pragma mark - Notification

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification{
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = CGRectGetMinY(keyboardRect);
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (keyboardY == CGRectGetHeight(self.view.frame)) {
                             self.contentView.frame = CGRectMake(CGRectGetMinX(self.contentView.frame), 64, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
                         } else {
                             CGFloat offset = keyboardY - CGRectGetHeight(self.contentView.frame);
                             if (offset < 64) {
                                 self.contentView.frame = CGRectMake(CGRectGetMinX(self.contentView.frame), offset, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
                             }
                         }
                     } completion:nil];
    self.contentTopConstraint.constant = self.contentView.frame.origin.y;
}

@end
