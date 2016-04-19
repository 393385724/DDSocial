//
//  DDSinaHandler.h
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

@interface DDSinaHandler : NSObject

@end

@interface DDSinaHandler (DDSocialHandlerProtocol) <DDSocialHandlerProtocol>

@end
