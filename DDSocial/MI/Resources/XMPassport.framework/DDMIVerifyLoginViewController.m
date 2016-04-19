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

#import "UIView+DDFrame.h"
#import "UIButton+DDHitTestEdgeInsets.h"

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
        self.requestHandle.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = MILocal(@"口令验证");
    
    //LeftBar
    UIButton* backButton= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setTitle:MILocal(@"返回") forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [backButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.trustButton.hitTestEdgeInsets = UIEdgeInsetsMake(-5, -10, -10, -10);
    self.confirmButton.enabled = NO;
    self.confirmButton.layer.borderWidth = 1;
    self.confirmButton.layer.cornerRadius = self.confirmButton.ddHeight/2.0;
    self.confirmButton.layer.borderColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1].CGColor;
    [self.confirmButton setBackgroundColor:[UIColor colorWithRed:252/255.0f green:252/255.0f blue:252/255.0f alpha:1]];
    [self.confirmButton setTitle:MILocal(@"确定") forState:UIControlStateNormal];
    
    //隐藏键盘
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.inputBackImageView.image = MIImage(@"dd_single_input_bg");
    
    self.tipLabel.text = MILocal(@"一个账号,玩转所有小米服务!");
    self.codeTextField.placeholder = MILocal(@"请输入6位动态口令");
    self.trustLabel.text = MILocal(@"这是我的私人设备,以后登录无需输入口令");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hidenKeyboard:nil];
}

#pragma mark - Button actions
- (void)backButtonAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewControllerNeedPop:)]) {
        [self.delegate viewControllerNeedPop:self];
    }
}

- (IBAction)trustButtonAction:(id)sender {
    self.isTrustDevice = !self.isTrustDevice;
    NSString *imageName = self.isTrustDevice ? @"dd_button_trust_icon" : @"dd_button_untrust_icon";
    [self.trustButton setImage:MIImage(imageName) forState:UIControlStateNormal];
}

- (IBAction)confirmButtonAction:(id)sender {
    [self.indicatorView startAnimation];
    self.confirmButton.enabled = NO;
    self.view.userInteractionEnabled = NO;
    [self.requestHandle checkOTPCode:self.codeTextField.text trustDevice:self.isTrustDevice];
}

#pragma mark -  DDMIRequestHandleDelegate

- (void)requestHandle:(DDMIRequestHandle *)requestHandle successedNeedDynamicToken:(BOOL)needDynamicToken{
    [self.indicatorView stopAnimation];
    self.confirmButton.enabled = YES;
    self.view.userInteractionEnabled = YES;
    if (needDynamicToken) {
        [self displayErrorTipLabelWithText:MILocal(@"动态口令错误")];
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewControllerDidVerifySucess:)]) {
            [self.delegate viewControllerDidVerifySucess:self];
        }
    }
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
                         if (keyboardY == self.view.ddHeight) {
                             self.contentView.ddTop = 64;
                         } else {
                             CGFloat offset = keyboardY - self.contentView.ddHeight;
                             if (offset < 64) {
                                 self.contentView.ddTop = offset;
                             }
                         }
                     } completion:nil];
    self.contentTopConstraint.constant = self.contentView.ddTop;
}

@end
