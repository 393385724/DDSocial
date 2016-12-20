//
//  MPEnDecryptCoder.h
//  MiPassportFoundation
//
//  Created by 李 业 on 13-12-3.
//  Copyright (c) 2013年 Xiaomi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MPEnDecryptCoder <NSObject>

- (NSString *)encryptString:(NSString *)plainString;
- (NSString *)decryptString:(NSString *)cipherString;

@end
