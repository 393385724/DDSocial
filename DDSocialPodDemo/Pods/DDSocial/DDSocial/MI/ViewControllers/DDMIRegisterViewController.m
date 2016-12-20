//
//  DDMIRegisterViewController.m
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/27.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDMIRegisterViewController.h"
#import "DDMICountryListViewController.h"
#import "DDMISMSVerifyViewController.h"
#import "DDMIAgreementAndPolicyViewController.h"

#import "DDMICircleIndicator.h"
#import "DDMIAttributedLabel.h"
#import "DDMIRegisterCodeView.h"

#import "DDMIRequestHandle.h"
#import "DDMIDownLoader.h"

#import "UIButton+DDMIHitTestEdgeInsets.h"
#import "DDMIVerifyPasswordTool.h"
#import "DDMITelephoneRule.h"
#import "DDMIURLEncode.h"
#import "DDMIErrorTool.h"

NSString * const DDMIAgreeMentHTML = @"http://www.miui.com/res/doc/eula/%@.html";
NSString * const DDMIPrivacyPolicyHTML = @"http://www.miui.com/res/doc/privacy/%@.html";

@interface DDMIRegisterViewController ()<UITextFieldDelegate, DDMIRegisterCodeViewDelegate, TTTAttributedLabelDelegate,DDMICountryListViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;

//input
@property (weak, nonatomic) IBOutlet UIImageView *inputBackImageView;
@property (weak, nonatomic) IBOutlet UILabel *areaCodeLabel;
@property (weak, nonatomic) IBOutlet UIView *countryContentView;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreCountryImageView;
@property (weak, nonatomic) IBOutlet UILabel *phoneTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *showPasswordButton;

@property (weak, nonatomic) IBOutlet UILabel *errorTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet DDMICircleIndicator *indicatorView;

@property (nonatomic, weak) DDMIRegisterCodeView *registerCodeView;

@property (weak, nonatomic) IBOutlet DDMIAttributedLabel *agreementAndPolicyLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTopConstraint;


@property (nonatomic, strong) DDMIRequestHandle *requestHandle;
@property (nonatomic, strong) DDMIDownLoader *downLoader;

@property (nonatomic, copy) NSString *phoneNumberString;

@end

@implementation DDMIRegisterViewController

- (instancetype)initWithRequestHandle:(DDMIRequestHandle *)requestHandle{
    self = [super initWithNibName:@"DDMIRegisterViewController" bundle:MIResourceBundle];
    if (self) {
        self.requestHandle = requestHandle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = MILocal(@"注册");
    self.showPasswordButton.miHitTestEdgeInsets = UIEdgeInsetsMake(-10, -20, -10, -10);
    
    self.registerButton.layer.borderWidth = 1;
    self.registerButton.layer.cornerRadius = CGRectGetHeight(self.registerButton.frame)/2.0;
    self.registerButton.layer.borderColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1].CGColor;
    [self.registerButton setBackgroundColor:[UIColor colorWithRed:252/255.0f green:252/255.0f blue:252/255.0f alpha:1]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreCountryAction)];
    self.countryContentView.userInteractionEnabled = YES;
    [self.countryContentView addGestureRecognizer:tap];
    
    //隐藏键盘
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    self.inputBackImageView.image = MIImage(@"dd_mi_register_input_bg");
    self.moreCountryImageView.image = MIImage(@"dd_mi_more_country@2x.jpg");
    self.phoneTextLabel.text = MILocal(@"手机号:");
    self.phoneTextLabel.adjustsFontSizeToFitWidth = YES;
    self.phoneTextField.placeholder = MILocal(@"请输入手机号");
    self.passwordTextLabel.text = MILocal(@"密码:");
    self.passwordTextLabel.adjustsFontSizeToFitWidth = YES;
    self.passwordTextField.placeholder = MILocal(@"8-16位数字、字母、字符(至少两种)");
    [self.showPasswordButton setImage:MIImage(@"dd_mi_show_password") forState:UIControlStateNormal];
    [self.showPasswordButton setImage:MIImage(@"dd_mi_hide_password@2x.jpg") forState:UIControlStateSelected];
    [self.registerButton setTitle:MILocal(@"注册") forState:UIControlStateNormal];
    NSString *remindFormatString = MILocal(@"点击\"注册\"代表您同意并接受小米的%@和%@");
    NSString *userAgreeMentString = MILocal(@"用户协议");
    NSString *privatePolicyString = MILocal(@"隐私政策");
    NSString *remindString = [NSString stringWithFormat:remindFormatString,userAgreeMentString,privatePolicyString];
    //用户协议点击范围
    NSRange userAgreeMentRange = [remindString rangeOfString:userAgreeMentString options:NSCaseInsensitiveSearch];
    //隐私策略点击范围
    NSRange privatePolicyRange = [remindString rangeOfString:privatePolicyString options:NSCaseInsensitiveSearch];
    [self.agreementAndPolicyLabel setText:remindString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //用户协议点击范围
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:36.0/255.0 green:153.0/255.0 blue:194.0/255.0 alpha:1.0] CGColor] range:userAgreeMentRange];
        [mutableAttributedString addAttribute:(NSString*)kCTUnderlineStyleAttributeName value:(id)@(NO) range:userAgreeMentRange];
        //隐私策略点击范围
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:36.0/255.0 green:153.0/255.0 blue:194.0/255.0 alpha:1.0] CGColor] range:privatePolicyRange];
        [mutableAttributedString addAttribute:(NSString*)kCTUnderlineStyleAttributeName value:(id)@(NO) range:privatePolicyRange];
        return mutableAttributedString;
    }];
    self.agreementAndPolicyLabel.delegate = self;
    [self.agreementAndPolicyLabel addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:DDMIAgreeMentHTML,MILocal(@"cn")]] withRange:userAgreeMentRange];
    [self.agreementAndPolicyLabel addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:DDMIPrivacyPolicyHTML,MILocal(@"cn")]] withRange:privatePolicyRange];
}

#pragma mark - Template Methods

- (DDMINavigationLeftBarAction)leftBarAction{
    return DDMINavigationLeftBarActionBack;
}

#pragma mark - Button Action

- (void)moreCountryAction {
    DDMICountryListViewController *viewController = [[DDMICountryListViewController alloc] init];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)showPasswordButtonAction:(id)sender {
    self.showPasswordButton.selected = !self.showPasswordButton.selected;
    self.passwordTextField.secureTextEntry = !self.showPasswordButton.selected;
}

- (IBAction)registerButtonAction:(id)sender {
    [self resignFirstTextFieldResponder];
    //验证密码
    NSString *passwordString = self.passwordTextField.text;
    BOOL isVailedPassword = [DDMIVerifyPasswordTool verifyPasswordString:passwordString];
    if (!isVailedPassword) {
        [self displayErrorTipLabelWithText:self.passwordTextField.placeholder];
        return;
    }
    
    //手机号编码
    if ([self.areaCodeLabel.text isEqualToString:@"+86"]) {
        self.phoneNumberString = self.phoneTextField.text;
    } else {
        self.phoneNumberString = [self.areaCodeLabel.text stringByAppendingString:[[[DDMITelephoneRule alloc] initWithDefaultRule] formatPhoneNum:self.phoneTextField.text]];
        self.phoneNumberString = [DDMIURLEncode encodeString:self.phoneNumberString];
    }
    [self.indicatorView startAnimation];
    self.view.userInteractionEnabled = NO;
    __weak __typeof(&*self)weakSelf = self;
    [self.requestHandle checkSMSQuotaWithPhoneNumber:self.phoneNumberString completeHandler:^(NSDictionary *responseDict, NSError *connectionError, NSString *errorMessage) {
        [weakSelf.indicatorView stopAnimation];
        weakSelf.view.userInteractionEnabled = YES;
        if (!connectionError) {
            weakSelf.registerCodeView = [DDMIRegisterCodeView registerCodeView];
            weakSelf.registerCodeView.delegate = self;
            [weakSelf.registerCodeView addTarget:self changeImageAction:@selector(changeCodeImage)];
            [weakSelf.registerCodeView show];
            [self changeCodeImage];
        } else {
            [self displayErrorTipLabelWithText:errorMessage];
        }
    }];
}

- (void)changeCodeImage{
    __weak __typeof(&*self)weakSelf = self;
    [self.downLoader loadRegisterCodeImageWithAccount:self.phoneNumberString completeHandle:^(NSData *data, NSError *error) {
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

#pragma mark - showErrorInfo

- (void)displayErrorTipLabelWithText:(NSString *)text{
    self.errorTipLabel.text = text;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.errorTipLabel.alpha = 1.0;
    } completion:nil];
}

#pragma mark - DDMICountryListViewControllerDelegate

- (void)countryListViewControllerDidSelectedCountryName:(NSString *)name code:(NSString *)code{
    self.areaCodeLabel.text = code;
    self.countryLabel.text = name;
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    NSString *title = @"";
    for (NSTextCheckingResult *result in label.links) {
        if ([result.URL.absoluteString isEqualToString:url.absoluteString]) {
            title = [label.text substringWithRange:result.range];
            break;
        }
    }
    DDMIAgreementAndPolicyViewController *viewController = [[DDMIAgreementAndPolicyViewController alloc] initWithTitle:title loadHTML:[url absoluteString]];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - DDMIRegisterCodeViewDelegate

- (void)registerCodeViewDidShow:(DDMIRegisterCodeView *)view{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerCodeViewDidDismiss:(DDMIRegisterCodeView *)view{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)registerCodeView:(DDMIRegisterCodeView *)view confirmWithCode:(NSString *)code{
    [self.indicatorView startAnimation];
    self.view.userInteractionEnabled = NO;
    __weak __typeof(&*self)weakSelf = self;
    [self.requestHandle sendPhoneTicket:code phoneNumber:self.phoneNumberString completeHandler:^(NSDictionary *responseDict, NSError *connectionError, NSString *errorMessage) {
        [weakSelf.indicatorView stopAnimation];
        weakSelf.view.userInteractionEnabled = YES;
        if (connectionError) {
            [self displayErrorTipLabelWithText:errorMessage];
        } else {
            [self gotoVerifySMSCodeViewController];
        }
    }];
}

- (void)gotoVerifySMSCodeViewController{
    DDMISMSVerifyViewController *viewController = [[DDMISMSVerifyViewController alloc] initWithRequestHandle:self.requestHandle phoneNumber:self.phoneNumberString passWord:self.passwordTextField.text];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self registerButtonStateChangedWithTextField:textField text:textField.text];
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
    [self registerButtonStateChangedWithTextField:textField text:tmpString];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.phoneTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self.passwordTextField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self registerButtonStateChangedWithTextField:textField text:nil];
    return YES;
}

- (void)registerButtonStateChangedWithTextField:(UITextField *)textField text:(NSString *)text{
    self.errorTipLabel.alpha = 0.0;
    
    NSString *phoneNumberString = self.phoneTextField.text;
    NSString *passwordString = self.passwordTextField.text;
    
    if (textField == self.phoneTextField) {
        phoneNumberString = text;
    } else if (textField == self.passwordTextField){
        passwordString = text;
    }
    if ([phoneNumberString length] && [passwordString length]) {
        self.registerButton.enabled = YES;
    } else {
        self.registerButton.enabled = NO;
    }
}

#pragma mark - Hiden Keyboard

- (void)hidenKeyboard:(UIGestureRecognizer *)recognizer{
    [self resignFirstTextFieldResponder];
}

- (void)resignFirstTextFieldResponder{
    if ([self.phoneTextField isFirstResponder]) {
        [self.phoneTextField resignFirstResponder];
    }
    if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
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
                             self.contentView.frame = CGRectMake(CGRectGetMinX(self.contentView.frame), 84, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
                         } else {
                             CGFloat offset = keyboardY - CGRectGetHeight(self.contentView.frame);
                             //fix bug the input box shows is not complete for 480 screen
                             if (CGRectGetHeight([UIScreen mainScreen].bounds) <= 480) {
                                 offset += 30;
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
