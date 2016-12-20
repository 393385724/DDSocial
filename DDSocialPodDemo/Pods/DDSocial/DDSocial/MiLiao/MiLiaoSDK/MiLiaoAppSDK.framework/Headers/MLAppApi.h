//
//  MLAppApi.h
//  MiLiaoAppSDK
//
//  Created by zhang weiliang on 13-3-22.
//  Copyright (c) 2013年 zhang weiliang. All rights reserved.
//

#import "MLBaseRequest.h"
#import "MLBaseResponse.h"

@protocol MLAppApiDelgate <NSObject>
@optional
/*
 * 收到一个来自米聊的请求，第三方处理后应调用sendResponse发送的米聊
 */
- (void)onRequest:(MLBaseRequest *)request;

/*
 * 收到一个来自米聊对于sendRequest的响应，第三方app根据response来处理错误信息
 */
- (void)onResponse:(MLBaseResponse *)response;

@end

@interface MLAppApi : NSObject

/*
 * 根据app的ios唯一标识生成一个sdk的唯一标识
 */
+ (NSString *)generateAppId:(NSString *)bundleIdentifier;

/* 
 * 向SDK注册由generateAppId生成的appId
 */
+ (BOOL)registerApp:(NSString *)appId;

/** 
 * 处理从米聊传递过来的响应
 * @url 是APP外部传递过来的URL，这里是米聊回复URL
 * @delegate 用来响应处理信息
 */
+ (BOOL)handOpenUrl:(NSURL *)url withDelegate:(id<MLAppApiDelgate>)delegate;

/**
 * 想米聊发送请求
 * @request 是第三方APP构造的请求对象
 */
+ (BOOL)sendRequest:(MLBaseRequest *)request;

/**
 * 想米聊发送请求
 * @url 是第三方APP构造的请求URL
 * @miliaoId 是第三方指定的发送的米聊账号
 */
+ (BOOL)sendRequest:(NSURL *)url forUser:(NSString *)miliaoId;

/**
 * 向米聊发送回复
 * @response 是第三方APP构造的响应对象
 */
+ (BOOL)sendResponse:(MLBaseResponse *)response;

/*
 * 获取SDK的版本
 */
+ (NSString *)getApiVersion;

/*
 * 获取设备上米聊支持的最高SDK版本号
 */
+ (NSString *)getMLAppSurpportMaxApiVersion;

/*
 * 获取米聊的App Store下载地址
 */
+ (NSString *)getMLInstallUrl;

/*
 * 判断设备上是否安装了米聊
 */
+ (BOOL)isMLAppInstalled;

/*
 * 判断设备上的米聊是否支持当前SDK的版本
 */
+ (BOOL)doseMLAppSupportApi;

@end
