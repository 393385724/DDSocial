//
//  DDGoogleHandler.h
//  DDSocialDemo
//
//  Created by lilingang on 16/4/11.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialHandlerProtocol.h"

@interface DDGoogleHandler : NSObject

@end

@interface DDGoogleHandler (DDSocialHandlerProtocol) <DDSocialHandlerProtocol>

@end