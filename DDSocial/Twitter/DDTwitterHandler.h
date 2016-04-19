//
//  DDTwitterHandler.h
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSocialEventDefs.h"

@protocol DDSocialShareContentProtocol;
@protocol DDSocialHandlerProtocol;
@class UIViewController;

@interface DDTwitterHandler : NSObject

@end

@interface DDTwitterHandler (DDSocialHandlerProtocol) <DDSocialHandlerProtocol>

@end
