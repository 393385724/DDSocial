//
//  DDMILoginViewController.m
//  HMLoginDemo
//
//  Created by lilingang on 15/8/4.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import "DDMILoginViewController.h"
#import "DDMIVerifyLoginViewController.h"
#import "DDMIForgetPasswordViewController.h"
#import "DDMIRegisterViewController.h"

#import "DDMICircleIndicator.h"

#import "DDMIRequestHandle.h"
#import "DDMIDownLoader.h"

#import "DDMIAccountManager.h"

typedef NS_ENUM(NSUInteger, DDMILoginType) {
    DDMILoginTypeDefault,
    DDMILoginTypeImageVerification,
};

@interface DDMILoginViewController ()<UITextFieldDelegate,DDMIRequestHandleDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UIImageView *inputbackImageView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@property (weak, nonatomic) IBOutlet UILabel *errorTipLabel;
@property (weak, nonatomic) IBOutlet DDMICircleIndicator *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputContentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgetPasswordTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerHorizontalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerBottomConstraint;

@property (nonatomic, assign) DDMILoginType loginType;
@property (nonatomic, strong) DDMIRequestHandle *requestHandle;
@property (nonatomic, strong) DDMIDownLoader *downLoader;

@end

@implementation DDMILoginViewController

- (instancetype)initWithRequestHandle:(DDMIRequestHandle *)requestHandle{
    self = [super initWithNibName:@"DDMILoginViewController" bundle:MIResourceBundle];
    if (self) {
        self.requestHandle = requestHandle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginType = DDMILoginTypeImageVerification;
    
    self.loginButton.enabled = NO;
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.cornerRadius = CGRectGetHeight(self.loginButton.frame)/2.0;
    self.loginButton.layer.borderColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1].CGColor;
    [self.loginButton setBackgroundColor:[UIColor colorWithRed:252/255.0f green:252/255.0f blue:252/255.0f alpha:1]];

    self.codeImageView.userInteractionEnabled = YES;
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeImageViewTap)];
    [self.codeImageView addGestureRecognizer:gesture];
    
    //隐藏键盘
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeRecognizer];
    
    self.logoImageView.image = MIImage(@"dd_mi_logo_icon");
    
    self.title = MILocal(@"登录");
    self.tipLabel.text = MILocal(@"请使用小米账号登录");
    self.accountTextField.placeholder = MILocal(@"邮箱/手机号/小米ID");
    self.passwordTextField.placeholder = MILocal(@"密码");
    self.codeTextField.placeholder = MILocal(@"验证码");
    [self.loginButton setTitle:MILocal(@"登录") forState:UIControlStateNormal];
    [self.forgetPasswordButton setTitle:MILocal(@"忘记密码?") forState:UIControlStateNormal];
    [self.registerButton setTitle:MILocal(@"注册小米账号") forState:UIControlStateNormal];
    self.accountTextField.text = [DDMIAccountManager userAccount];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //重置接受者
    self.requestHandle.delegate = self;
    [self switchLoginType:DDMILoginTypeDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self hidenKeyboard:nil];
}

#pragma mark - Actions

- (IBAction)loginButtonAction:(id)sender{
    [self hidenKeyboard:nil];
    self.errorTipLabel.alpha = 0.0;
    NSString *account = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *code = self.codeTextField.text;
    
    if (MIIsEmptyString(account)) {
        [self displayAndAutoDisMissErrorTipLabelWithText:MILocal(@"账号不能为空")];
        return;
    }
    if (MIIsEmptyString(password)) {
        [self displayAndAutoDisMissErrorTipLabelWithText:MILocal(@"密码不能为空")];
        return;
    }
    
    if (self.loginType == DDMILoginTypeImageVerification && MIIsEmptyString(code)) {
        [self displayAndAutoDisMissErrorTipLabelWithText:MILocal(@"验证码不能为空")];
        return;
    }
    
    self.loginButton.enabled = NO;
    self.view.userInteractionEnabled = NO;
    if (self.loginType == DDMILoginTypeImageVerification) {
        [self.requestHandle loginWithAccount:account password:password verifyCode:code];
    }
    else {
        [self.requestHandle loginWithAccount:account password:password verifyCode:nil];
    }
    [self.indicatorView startAnimation];
}

- (void)codeImageViewTap{
    [self changeImageVerificationCodeWithURLString:nil];
}

- (IBAction)forgetPasswordButtonAction:(id)sender {
    DDMIForgetPasswordViewController *viewController = [[DDMIForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)registerButtonAction:(id)sender {
    DDMIRegisterViewController *viewController = [[DDMIRegisterViewController alloc] initWithRequestHandle:self.requestHandle];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pushToVerifyLoginViewController{
    DDMIVerifyLoginViewController *viewController = [[DDMIVerifyLoginViewController alloc] initWithRequestHandle:self.requestHandle];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Private Methods

- (void)switchLoginType:(DDMILoginType)loginType{
    if (self.loginType == loginType) {
        return;
    }
    self.loginType = loginType;
    CGFloat contentViewHeight = 0;
    CGFloat inputbackImageViewHeight = 0;
    if (loginType == DDMILoginTypeDefault) {
        self.codeTextField.hidden = YES;
        self.codeImageView.hidden = YES;
        self.passwordTextField.returnKeyType = UIReturnKeyDone;

        contentViewHeight = 381;
        inputbackImageViewHeight = 112;
        self.inputbackImageView.image = MIImage(@"dd_mi_login_input_bg");
        if ([UIScreen mainScreen].bounds.size.height <= 480) {
            self.forgetPasswordTopConstraint.constant = 8.0;
            self.registerHorizontalConstraint.constant = 0.0;
            self.registerBottomConstraint.constant = 8.0;
        }
    } else {
        self.codeTextField.hidden = NO;
        self.codeImageView.hidden = NO;
        self.passwordTextField.returnKeyType = UIReturnKeyNext;
        self.loginButton.enabled = NO;

        contentViewHeight = 430;
        inputbackImageViewHeight = 162;
        self.inputbackImageView.image = MIImage(@"dd_mi_login_input_bg_verification");
        if ([UIScreen mainScreen].bounds.size.height <= 480) {
            self.forgetPasswordTopConstraint.constant = 0;
            self.registerHorizontalConstraint.constant = -60;
            self.registerBottomConstraint.constant = 0.0;
        }
    }
    self.contentView.frame = CGRectMake(CGRectGetMinX(self.contentView.frame), CGRectGetMinY(self.contentView.frame), CGRectGetWidth(self.contentView.frame), contentViewHeight);
    self.inputbackImageView.frame = CGRectMake(CGRectGetMinX(self.inputbackImageView.frame), CGRectGetMinY(self.inputbackImageView.frame), CGRectGetWidth(self.inputbackImageView.frame), inputbackImageViewHeight);
    self.contentViewHeightConstraint.constant = CGRectGetHeight(self.contentView.frame);
    self.inputContentViewHeightConstraint.constant = CGRectGetHeight(self.inputbackImageView.frame);
}

- (void)changeImageVerificationCodeWithURLString:(NSString *)urlString{
    self.codeImageView.userInteractionEnabled = NO;
    __weak __typeof(&*self)weakSelf = self;
    [self.downLoader loadLoginCodeImageWithURLString:urlString account:self.accountTextField.text completeHandle:^(NSData *data, NSError *error) {
        if (error) {
            NSString *errorMessage = [DDMIErrorTool errorMessageWithError:error];
            [weakSelf displayErrorTipLabelWithText:errorMessage];
        } else {
            UIImage *codeImage = [UIImage imageWithData:data];
            weakSelf.codeImageView.image = codeImage;
        }
        weakSelf.codeImageView.userInteractionEnabled = YES;
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self loginButtonStateChangedWithTextField:textField text:textField.text];
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
    [self loginButtonStateChangedWithTextField:textField text:tmpString];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.accountTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        if (self.loginType == DDMILoginTypeDefault) {
            [self.passwordTextField resignFirstResponder];
        }
        else {
            if (textField == self.passwordTextField){
                [self.codeTextField becomeFirstResponder];
            } else {
                [self.codeTextField resignFirstResponder];
            }
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self loginButtonStateChangedWithTextField:textField text:nil];
    return YES;
}

- (void)loginButtonStateChangedWithTextField:(UITextField *)textField text:(NSString *)text{
    self.errorTipLabel.alpha = 0.0;

    NSString *accountString = self.accountTextField.text;
    NSString *passwordString = self.passwordTextField.text;
    NSString *codeString = self.codeTextField.text;
    if (textField == self.accountTextField) {
        accountString = text;
    } else if (textField == self.passwordTextField){
        passwordString = text;
    } else if (textField == self.codeTextField){
        codeString = text;
    }
    if ([accountString length] && [passwordString length]) {
        if ((self.loginType == DDMILoginTypeImageVerification && [codeString length]) ||
            self.loginType == DDMILoginTypeDefault) {
            self.loginButton.enabled = YES;
        } else {
            self.loginButton.enabled = NO;
        }
    }
    else {
        self.loginButton.enabled = NO;
    }
}

#pragma mark - DDMIRequestHandleDelegate

- (void)requestHandleDidSuccess:(DDMIRequestHandle *)requestHandle{
    [self.indicatorView stopAnimation];
    self.loginButton.enabled = YES;
    self.view.userInteractionEnabled = YES;
    [DDMIAccountManager saveUserAccount:self.accountTextField.text];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDMILoginAuthNotification object:nil];
}

- (void)requestHandle:(DDMIRequestHandle *)requestHandle failedWithType:(DDMIErrorType)errorType errorMessage:(NSString *)errorMessage error:(NSError *)error{
    [self.indicatorView stopAnimation];
    self.loginButton.enabled = YES;
    self.view.userInteractionEnabled = YES;
    if (errorType == DDMIErrorNeedDynamicToken){
        [self pushToVerifyLoginViewController];
        return;
    }
    if (errorType == DDMIErrorVerificationCode) {
        if (self.loginType == DDMILoginTypeDefault) {
            [self switchLoginType:DDMILoginTypeImageVerification];
            errorMessage = MILocal(@"请输入验证码");
        }
        UIImage *captImage = [error.userInfo objectForKey:@"captImage"];
        if (captImage) {
            self.codeImageView.image = captImage;
        } else {
            NSString *captchaUrl = [error.userInfo objectForKey:@"captchaUrl"];
            [self changeImageVerificationCodeWithURLString:captchaUrl];
        }
    }
    [self displayErrorTipLabelWithText:errorMessage];
}

- (void)displayErrorTipLabelWithText:(NSString *)text{
    self.errorTipLabel.text = text;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.errorTipLabel.alpha = 1.0;
    } completion:nil];
}

- (void)displayAndAutoDisMissErrorTipLabelWithText:(NSString *)text{
    self.errorTipLabel.text = text;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.errorTipLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.errorTipLabel.alpha = 0.0;
            } completion:nil];
        });
    }];
}


#pragma mark - Hiden Keyboard

- (void)hidenKeyboard:(UIGestureRecognizer *)recognizer{
    if ([self.accountTextField isFirstResponder]) {
        [self.accountTextField resignFirstResponder];
    }
    if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
    }
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
                             //fix bug the input box shows is not complete for 480 screen
                             if (CGRectGetHeight([UIScreen mainScreen].bounds) <= 480) {
                                 if ([self.accountTextField isFirstResponder]) {
                                     offset += 30; 
                                 }
                                 offset += 43;
                             }
                             if (offset < 64) {
                                 self.contentView.frame = CGRectMake(CGRectGetMinX(self.contentView.frame), offset, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
                             }
                         }
                     } completion:nil];
    self.contentViewTopConstraint.constant = CGRectGetMinY(self.contentView.frame);
}

#pragma mark - Getter and Setter

- (DDMIDownLoader *)downLoader{
    if (!_downLoader) {
        _downLoader = [[DDMIDownLoader alloc] init];
    }
    return _downLoader;
}

@end
