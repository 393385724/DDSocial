//
//  DDMIDownLoader.m
//  HMLoginDemo
//
//  Created by lilingang on 15/8/5.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import "DDMIDownLoader.h"

@implementation DDMIDownLoader

- (void)loadLoginCodeImageWithURLString:(NSString *)urlString
                                account:(NSString *)account
                         completeHandle:(DDMIDownLoaderEventHandler)completeHandle{
    if ([urlString length]) {
        NSString *url = [@"https://account.xiaomi.com" stringByAppendingString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (completeHandle) {
            completeHandle(data,nil);
        }
        return;
    }
    NSString *url = [NSString stringWithFormat:@"https://account.xiaomi.com/pass/getCode?icodeType=login&phone=%@",account];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request
                                                            completionHandler:
                                              ^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                  if (error) {
                                                      completeHandle(nil, error);
                                                  } else {
                                                      NSData *data = [NSData dataWithContentsOfURL:location];
                                                      completeHandle(data, error);
                                                  }
                                              }];
    
    [downloadTask resume];
}

- (void)loadRegisterCodeImageWithAccount:(NSString *)account
                         completeHandle:(DDMIDownLoaderEventHandler)completeHandle{
    NSString *url = [NSString stringWithFormat:@"https://account.xiaomi.com/pass/getCode?icodeType=register&phone=%@",account];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request
                                                            completionHandler:
                                              ^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                  if (error) {
                                                      completeHandle(nil, error);
                                                  } else {
                                                      NSData *data = [NSData dataWithContentsOfURL:location];
                                                      completeHandle(data, error);
                                                  }
                                              }];
    
    [downloadTask resume];
}
@end
