//
//  DDMISMSVerifyViewController.m
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/29.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDMISMSVerifyViewController.h"
#import "DDMIHelpViewController.h"

#import "DDMICircleIndicator.h"
#import "DDMIRegisterCodeView.h"

#import "DDMIRequestHandle.h"
#import "DDMIDownLoader.h"
#import "DDMIAccountManager.h"

@interface DDMISMSVerifyViewController ()<UITextFieldDelegate,DDMIRegisterCodeViewDelegate, DDMIRequestHandleDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *inputBackImageView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet DDMICircleIndicator *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;

@property (nonatomic, weak) DDMIRegisterCodeView *registerCodeView;

@property (nonatomic, strong) DDMIRequestHandle *requestHandle;
@property (nonatomic, strong) DDMIDownLoader *downLoader;

@property (nonatomic, strong) NSTimer *countdownTimer;

@end

@implementation DDMISMSVerifyViewController{
    NSString *_phoneNumber;
    NSString *_password;
    NSInteger _countdownSeconds;
}

- (instancetype)initWithRequestHandle:(DDMIRequestHandle *)requestHandle
                          phoneNumber:(NSString *)phoneNumber
                             passWord:(NSString *)password{
    self = [super initWithNibName:@"DDMISMSVerifyViewController" bundle:MIResourceBundle];
    if (self) {
        self.requestHandle = requestHandle;
        _phoneNumber = phoneNumber;
        _password = password;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = MILocal(@"验证码");
    //高亮的电话号码
    NSString *string = [NSString stringWithFormat:MILocal(@"已向手机%@发送了验证码短信"),_phoneNumber];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange phoneNumberRange = [string rangeOfString:_phoneNumber];
    if (phoneNumberRange.length) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:252/255.0f green:87/255.0f blue:29/255.0f alpha:1] range:phoneNumberRange];
    }
    self.titleLabel.attributedText = attributedString;
    
    self.nextButton.layer.borderWidth = 1;
    self.nextButton.layer.cornerRadius = CGRectGetHeight(self.nextButton.frame)/2.0;
    self.nextButton.layer.borderColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1].CGColor;
    
    //隐藏键盘
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeRecognizer];
    
    self.inputBackImageView.image = MIImage(@"dd_mi_sms_code_bg_image");
    self.inputTextField.placeholder = MILocal(@"请输入验证码");
    [self.resendButton setTitle:MILocal(@"重新发送") forState:UIControlStateNormal];
    [self.resendButton setBackgroundImage:MIImage(@"dd_mi_resend_bg_normal") forState:UIControlStateNormal];
    [self.resendButton setBackgroundImage:MIImage(@"dd_mi_resend_bg_disable") forState:UIControlStateDisabled];
    [self.nextButton setTitle:MILocal(@"下一步") forState:UIControlStateNormal];
    [self.helpButton setTitle:MILocal(@"我为何收不到验证码?") forState:UIControlStateNormal];
    [self startCountdown];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - Template Method

- (DDMINavigationLeftBarAction)leftBarAction{
    return DDMINavigationLeftBarActionBack;
}

- (void)backButtonAction:(id)sender{
    [self stopCountdown];
    [super backButtonAction:sender];
}


#pragma mark - Private Methds

- (void)startCountdown{
    _countdownSeconds = 60;
    self.resendButton.enabled = NO;
    self.countDownLabel.hidden = NO;
    self.countDownLabel.text = [NSString stringWithFormat:@"%lds",(long)_countdownSeconds];
    self.countdownTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(countdownTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.countdownTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopCountdown{
    self.resendButton.enabled = YES;
    self.countDownLabel.hidden = YES;
    [self.resendButton setTitle:MILocal(@"重新发送") forState:UIControlStateNormal];
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
}

- (void)countdownTimerAction{
    _countdownSeconds --;
    if (_countdownSeconds == 0) {
        [self stopCountdown];
    } else {
        self.countDownLabel.text = [NSString stringWithFormat:@"%lds",(long)_countdownSeconds];
    }
}

- (void)changeCodeImage{
    __weak __typeof(&*self)weakSelf = self;
    [self.downLoader loadRegisterCodeImageWithAccount:_phoneNumber completeHandle:^(NSData *data, NSError *error) {
        if (error) {
            NSString *errorMessage = [DDMIErrorTool errorMessageWithError:error];
            [weakSelf.registerCodeView displayErrorText:errorMessage];
        }
        else {
            UIImage *codeImage = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.registerCodeView updateImage:codeImage];
            });
        }
    }];
}

#pragma mark - showInfo

- (void)displayErrorTipLabelWithText:(NSString *)text{
    self.errorTipLabel.text = text;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.errorTipLabel.alpha = 1.0;
    } completion:nil];
}

#pragma mark - Button Action

- (IBAction)resendButtonAction:(id)sender {
    [self.indicatorView startAnimation];
    self.view.userInteractionEnabled = NO;
    __weak __typeof(&*self)weakSelf = self;
    [self.requestHandle checkSMSQuotaWithPhoneNumber:_phoneNumber completeHandler:^(NSDictionary *responseDict, NSError *connectionError, NSString *errorMessage) {
        [weakSelf.indicatorView stopAnimation];
        weakSelf.view.userInteractionEnabled = YES;
        if (connectionError) {
            [self displayErrorTipLabelWithText:errorMessage];
        } else {
            weakSelf.registerCodeView = [DDMIRegisterCodeView registerCodeView];
            weakSelf.registerCodeView.delegate = self;
            [weakSelf.registerCodeView addTarget:self changeImageAction:@selector(changeCodeImage)];
            [weakSelf.registerCodeView show];
            [self changeCodeImage];
        }
    }];
}

- (IBAction)nextButtonAction:(id)sender {
    [self.indicatorView startAnimation];
    self.view.userInteractionEnabled = NO;
    __weak __typeof(&*self)weakSelf = self;
    [self.requestHandle registerAccountWithPhoneNumber:_phoneNumber password:_password smsCode:self.inputTextField.text completeHandler:^(NSDictionary *responseDict, NSError *connectionError, NSString *errorMessage) {
        if (connectionError) {
            [weakSelf.indicatorView stopAnimation];
            weakSelf.view.userInteractionEnabled = YES;
            [self displayErrorTipLabelWithText:errorMessage];
        } else {
            [weakSelf.requestHandle loginWithAccount:_phoneNumber password:_password verifyCode:nil];
            weakSelf.requestHandle.delegate = self;
        }
    }];
}

- (IBAction)helpButtonAction:(id)sender {
    DDMIHelpViewController *viewController = [[DDMIHelpViewController alloc] initWithPhoneNumber:_phoneNumber];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - DDMIRegisterCodeViewDelegate

- (void)registerCodeView:(DDMIRegisterCodeView *)view confirmWithCode:(NSString *)code{
    [self startCountdown];
    [self.requestHandle sendPhoneTicket:code phoneNumber:_phoneNumber completeHandler:^(NSDictionary *responseDict, NSError *connectionError, NSString *errorMessage) {
        if (connectionError) {
            [self displayErrorTipLabelWithText:errorMessage];
        }
    }];
}

#pragma mark - DDMIRegisterCodeViewDelegate

- (void)requestHandleDidSuccess:(DDMIRequestHandle *)requestHandle{
    [self.indicatorView stopAnimation];
    self.nextButton.enabled = YES;
    self.view.userInteractionEnabled = YES;
    //进入主页面
    [DDMIAccountManager saveUserAccount:_phoneNumber];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDMILoginAuthNotification object:nil];
}

- (void)requestHandle:(DDMIRequestHandle *)requestHandle failedWithType:(DDMIErrorType)errorType errorMessage:(NSString *)errorMessage error:(NSError *)error{
    [self.indicatorView stopAnimation];
    self.nextButton.enabled = YES;
    self.view.userInteractionEnabled = YES;
    [self displayErrorTipLabelWithText:errorMessage];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self nextButtonStateChangedWithTextField:textField text:textField.text];
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
    [self nextButtonStateChangedWithTextField:textField text:tmpString];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.inputTextField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self nextButtonStateChangedWithTextField:textField text:nil];
    return YES;
}

- (void)nextButtonStateChangedWithTextField:(UITextField *)textField text:(NSString *)text{
    self.errorTipLabel.alpha = 0.0;
    if ([text length]) {
        self.nextButton.enabled = YES;
    } else {
        self.nextButton.enabled = NO;
    }
}

#pragma mark - Hiden Keyboard

- (void)hidenKeyboard:(UIGestureRecognizer *)recognizer{
    [self.inputTextField resignFirstResponder];
}

#pragma mark - Getter and Setter

- (DDMIDownLoader *)downLoader{
    if (!_downLoader) {
        _downLoader = [[DDMIDownLoader alloc] init];
    }
    return _downLoader;
}

@end
