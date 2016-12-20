//
//  DDSoicalRequestHandler.h
//  DDSocialCodeDemo
//
//  Created by lilingang on 16/4/19.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDSoicalRequestHandler : NSObject

/**
 *  @brief 根据给定的URL和params发送get请求
 *
 *  @param urlString      请求的URL地址
 *  @param params         参数
 *  @param compleleHandle 回调
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)sendAsynWithURL:(NSString *)urlString
                                   params:(NSDictionary *)params
                           completeHandle:(void(^)(NSDictionary *responseDict, NSError *connectionError))compleleHandle;

@end
