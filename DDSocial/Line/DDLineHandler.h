//
//  DDLineHandler.h
//  DDSocialCodeDemo
//
//  Created by 李林刚 on 2017/9/26.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialHandlerProtocol.h"

@interface DDLineHandler : NSObject

@end

@interface DDLineHandler (DDSocialHandlerProtocol) <DDSocialHandlerProtocol>

@end
