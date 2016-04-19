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
[[NSBundle mainBundle] pathForResource: @ "DDMIResource" ofType :@ "bundle"]
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


#endif /* DDMIDefines_h */
