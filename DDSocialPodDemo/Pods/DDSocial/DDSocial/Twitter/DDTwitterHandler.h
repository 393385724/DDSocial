//
//  DDTwitterHandler.h
//  DDSocialDemo
//
//  Created by dingdaojun on 16/1/4.
//  Copyright © 2016年 dingdaojun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialHandlerProtocol.h"

@interface DDTwitterHandler : NSObject

@end

@interface DDTwitterHandler (DDSocialHandlerProtocol) <DDSocialHandlerProtocol>

@end
