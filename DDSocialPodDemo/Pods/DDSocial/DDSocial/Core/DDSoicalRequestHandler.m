//
//  DDSoicalRequestHandler.m
//  DDSocialCodeDemo
//
//  Created by lilingang on 16/4/19.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDSoicalRequestHandler.h"

@implementation DDSoicalRequestHandler

+ (NSURLSessionDataTask *)sendAsynWithURL:(NSString *)urlString
                                   params:(NSDictionary *)params
                           completeHandle:(void(^)(NSDictionary *responseDict, NSError *connectionError))compleleHandle{
    if (!compleleHandle) {
        return nil;
    }
    NSString *paramString = @"";
    for (NSString *keyString in [params allKeys]) {
        NSString *value = params[keyString];
        paramString = [paramString stringByAppendingFormat:@"%@=%@&",keyString,value];
    }
    paramString  = [paramString substringToIndex:[paramString length] - 1];
    urlString = [[urlString stringByAppendingString:@"?"] stringByAppendingString:paramString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            compleleHandle(nil, error);
        } else {
            NSError *jsonError = nil;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError) {
                compleleHandle(nil, jsonError);
            } else {
                compleleHandle(jsonDict, nil);
            }
        }
    }];
    [dataTask resume];
    return dataTask;
}

@end
