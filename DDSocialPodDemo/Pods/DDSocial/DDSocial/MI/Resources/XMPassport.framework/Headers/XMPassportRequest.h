//
//  XMPassportRequest.h
//  MiPassportFoundation
//
//  Created by 李 业 on 13-10-29.
//  Copyright (c) 2013年 Xiaomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPEnDecryptCoder.h"

@protocol XMPassportRequestDelegate;

@interface XMPassportRequest : NSObject{
    NSURLConnection *_connection;
    NSMutableData *_responseData;
}

@property(nonatomic,assign) id<XMPassportRequestDelegate> delegate;

/**
 * The URL which will be contacted to execute the request.
 */
@property(nonatomic, strong) NSString *url;

/**
 * The API method which will be called.
 */
@property(nonatomic, strong) NSString *httpMethod;

/**
 * The cookies which will be setted in the request.
 */
@property(nonatomic, strong) NSMutableArray *httpCookies;

/**
 * The dictionary of parameters to pass to the method.
 *
 * These values in the dictionary will be converted to strings using the
 * standard Objective-C object-to-string conversion facilities.
 */
@property(nonatomic,strong) NSMutableDictionary* params;

@property(nonatomic, strong) id<MPEnDecryptCoder> cryptCoder;

- (id)initWithWithParams:(NSMutableDictionary *) params
              httpMethod:(NSString *) httpMethod
                 cookies:(NSMutableArray *)cookies
                delegate:(id<XMPassportRequestDelegate>) delegate
              requestURL:(NSString *) url;

// crypt and sign, call this method if needed
- (void)cryptWithCoder:(id<MPEnDecryptCoder>)coder
   andSignWithSecurity:(NSString *)security;

- (void)connect;

+ (XMPassportRequest *)requestWithParams:(NSMutableDictionary *) params
                              httpMethod:(NSString *) httpMethod
                                 cookies:(NSMutableArray *)cookies
                                delegate:(id<XMPassportRequestDelegate>) delegate
                              requestURL:(NSString *) url;

+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;

+ (NSString *)urlEncode:(NSString*)str;
+ (NSString*)urlDecode:(NSString*)str;

+ (NSString *)generateSignatureWithMethod:(NSString *)method
                               requestUrl:(NSString *)requestUrl
                                   params:(NSDictionary *)params
                                 security:(NSString *)security;
@end


////////////////////////////////////////////////////////////////////////////////

/*
 *Your application should implement this delegate
 */
@protocol XMPassportRequestDelegate <NSObject>

@optional

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(XMPassportRequest *)request;

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(XMPassportRequest *)request didReceiveResponse:(NSURLResponse *)response;

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(XMPassportRequest *)request didFailWithError:(NSError *)error;

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(XMPassportRequest *)request didLoad:(id)result;

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(XMPassportRequest *)request didLoadRawResponse:(NSData *)data;

@end

