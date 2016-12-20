//
//  XMPassport.h
//  MiPassportFoundation
//
//  Created by 李 业 on 13-10-23.
//  Copyright (c) 2013年 Xiaomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPassportRequest.h"

@protocol MPSessionDelegate;

@interface XMPassport : NSObject
<XMPassportRequestDelegate>

@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* sid;
@property (nonatomic, strong) NSString* callbackUrl;
@property (nonatomic, strong) NSString* deviceId;
@property (nonatomic, strong) NSString* passToken;
@property (nonatomic, strong) NSString* serviceToken;
@property (nonatomic, strong) NSString* sSecurity;
@property (nonatomic, assign) long long nonce;

@property (nonatomic, weak) id<MPSessionDelegate> sessionDelegate;

@property (nonatomic, assign) BOOL forTest; //set TRUE if application wanna connect to staging server

/**
 * Initialize a passport to login or do other requests
 */
- (id)initWithUserId:(NSString *)userId
                 sid:(NSString *)sid
         andDelegate:(id<MPSessionDelegate>)delegate;

/**
 * load from and save to local persistence
 * return all settings are loaded or saved, and none is nil
 */
- (BOOL)loadFromLocalSettings;
- (BOOL)saveToLocalSettings;

/**
 * Call this method if your application tend to use webview to login rather than constructing your own native view
 */
- (void)showLoginWebView;
- (void)showLoginWebViewWithURL:(NSString *)url
                     authParams:(NSMutableDictionary *)authParams;
/**
 * Check if passport is logged in
 */
- (BOOL)isSessionValid;

/**
 * Login passport with password
 */
- (void)loginWithPassword:(NSString *)password
           encryptedOrNot:(BOOL) bEncrypted;

/**
 * Your application call this method to relogin passport, usually for refreshing passtoken and service token.
 * It is necessary to ensure your passport session is valid
 */
- (void)reLogin;

/**
 * Call this method to log out passport
 */
- (void)logOut;

/**
 * Login passport with password and verify code
 */
- (void)loginWithPassword:(NSString *)password
           encryptedOrNot:(BOOL) bEncrypted
            andVerifyCode:(NSString *)verifyCode;

/**
 * If user need two step login, this method is called for check one-time-password in the second step
 */
- (void)checkOTPCode:(NSString *)OTPCode
          trustOrNot:(BOOL) bTrust;

/**
 * create a request for xiaomi api, with signature or encryption if needed
 */
- (XMPassportRequest *)requestWithURL:(NSString *)url
                               params:(NSMutableDictionary *)params
                           httpMethod:(NSString *)httpMethod
                             delegate:(id<XMPassportRequestDelegate>)_delegate
                        needSignature:(BOOL)bNeedSignature
                                coder:(id<MPEnDecryptCoder>)coder;

- (BOOL)handleOpenURL:(NSURL *)url;

/**
 * generate signature for request with passport info
 */
- (NSString *)generateSignatureWithMethod:(NSString *)method
                               requestUrl:(NSString *)requestUrl
                                   params:(NSDictionary *)params;

@end

#pragma mark - MPSesssionDelegate
/**
 * Your application should implement this delegate to receive session callbacks.
 */
@protocol MPSessionDelegate <NSObject>

@optional

/**
 * Called when the user successfully logged in.
 */
- (void)passportDidLogin:(XMPassport *)passport;
/**
 * Called when the user failed to log in.
 */
- (void)passport:(XMPassport *)passport failedWithError:(NSError *)error;

/**
 * Called when the user logged out.
 *
 */
//- (void)passportDidLogout:(XMPassport *)passport;

/**
 * Called when passport session expired.
 */
- (void)passport:(XMPassport *)passport passSessionInvalidOrExpired:(NSError *)error;

@end
