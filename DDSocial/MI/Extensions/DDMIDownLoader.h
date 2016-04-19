//
//  DDMIDownLoader.h
//  HMLoginDemo
//
//  Created by lilingang on 15/8/5.
//  Copyright (c) 2015年 lilingang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DDMIDownLoaderEventHandler) (NSData *data, NSError *error);

@interface DDMIDownLoader : NSObject

- (void)loadLoginCodeImageWithURLString:(NSString *)urlString
                                account:(NSString *)account
                         completeHandle:(DDMIDownLoaderEventHandler)completeHandle;

@end
