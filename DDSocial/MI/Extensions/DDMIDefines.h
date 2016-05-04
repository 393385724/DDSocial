//
//  DDMIDefines.h
//  MDLoginSDK
//
//  Created by lilingang on 16/1/19.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#ifndef DDMIDefines_h
#define DDMIDefines_h

#ifndef MIResourceBundlePath
#define MIResourceBundlePath \
[[NSBundle mainBundle] pathForResource:@"DDMIResource" ofType:@"bundle"]
#endif

#ifndef MIResourceBundle
#define MIResourceBundle \
[NSBundle bundleWithPath:MIResourceBundlePath]
#endif

#ifndef MILocal
#define MILocal(s) \
[MIResourceBundle localizedStringForKey:s value:s table:@"DDMILocalizable"]
#endif

#ifndef MIImage
#define MIImage(s) \
[UIImage imageWithContentsOfFile:[MIResourceBundlePath stringByAppendingPathComponent:s]]
#endif

#ifndef MIIsEmptyString
#define MIIsEmptyString(objStr)\
(![objStr isKindOfClass:[NSString class]] || objStr == nil || [objStr length] <= 0)
#endif

/**
 *  @brief 登录授权的通知
 */
static NSString * const DDMILoginAuthNotification = @"DDMILoginAuthNotification";
/**
 *  @brief 取消登录的通知
 */
static NSString * const DDMILoginCancelNotification = @"DDMILoginCancelNotification";


#endif /* DDMIDefines_h */
