# DDSocial
A share auth wheels based on the official library content wecaht sina tencent facebook twitter google
#准备工作
###微信开放平台(https://open.weixin.qq.com/)
  (1)首先在微信开放平台根据自己app的bundleid申请一个appkey<br />
  (2)然后配置xcode中的info.plist 添加URL Types<br />
  (3)示例代码<br />
  <pre><code>
  <key>CFBundleURLTypes&lt</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>WeChat</string>
			<key>CFBundleURLName</key>
			<string>weixin</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>wx***********</string>
			</array>
		</dict>
	</array>
	</code></pre>
###QQ互联(http://connect.qq.com/)
  与微信类似
###新浪微博开放平台(http://open.weibo.com/)
  与微信类似唯一的区别是可以选择是否使用自定义的重定向URL
###Google开放平台(https://developers.google.com/identity/sign-in/ios/)
  goole略有不同 参见连接:https://developers.google.com/identity/sign-in/ios/start-integrating#before_you_begin
###Facebook开放平台(https://developers.facebook.com/)
  详情查看:https://developers.facebook.com/docs/ios/getting-started
###Twitter开放平台(https://apps.twitter.com/)
#分享
1、在AppDelegate.h中实现如下方法
(1)引入头文件
<pre><code>
#import "DDSocialShareHandler.h"
</code></pre>
(2)在应用启动时注册第三方eg
<pre><code>
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformWeChat appKey:自己申请的key];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformSina appKey:自己申请的key];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformQQ appKey:自己申请的key];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformFacebook appKey:自己申请的key];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformGoogle appKey:@""];
    return YES;
}
</code></pre>
(3)实现唤起app回调
<pre><code>
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[DDSocialShareHandler sharedInstance] application:application handleOpenURL:url sourceApplication:nil annotation:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[DDSocialShareHandler sharedInstance] application:application handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    return [[DDSocialShareHandler sharedInstance] application:app openURL:url options:options];
}
</code></pre>
2、调用方式
（1）实现分享的protocol<br />
DDSocialShareTextProtocol:纯文本分享<br />
DDSocialShareImageProtocol：图片分享<br />
DDSocialShareWebPageProtocol：web内容分享<br />
（2）分享代码
<pre><code>
[[DDSocialShareHandler sharedInstance] shareWithPlatform:DDSSPlatformWeChat controller:self shareScene:DDSSSceneWXSession contentType:DDSSContentTypeImage protocol:self handler:^(DDSSPlatform platform, DDSSScene scene, DDSSShareState state, NSError *error) {
        switch (state) {
            case DDSSShareStateBegan: {
                NSLog(@"开始分享");
                break;
            }
            case DDSSShareStateSuccess: {
                NSLog(@"分享成功");
                break;
            }
            case DDSSShareStateFail: {
                NSLog(@"分享失败：%@",error);
                break;
            }
            case DDSSShareStateCancel: {
                NSLog(@"取消分享");
                break;
            }
        }
    }];
</code></pre>
#授权
1、在AppDelegate.h中实现如下方法
(1)引入头文件
<pre><code>
#import "DDSocialShareHandler.h"
#import "DDSocialShareHandler.h"
</code></pre>
(2)在应用启动时注册第三方eg
<pre><code>
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[DDSocialAuthHandler sharedInstance] registerMIApp:自己申请的key redirectURL:自己填写的url];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformGoogle appKey:@""];

    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformWeChat appKey:自己申请的key];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformSina appKey:自己申请的key];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformQQ appKey:自己申请的key];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformFacebook appKey:自己申请的key];
    return YES;
}
</code></pre>
(3)实现唤起app回调
<pre><code>
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[DDSocialShareHandler sharedInstance] application:application handleOpenURL:url sourceApplication:nil annotation:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[DDSocialShareHandler sharedInstance] application:application handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    return [[DDSocialShareHandler sharedInstance] application:app openURL:url options:options];
}
</code></pre>
2、调用方式
<pre><code>
[[DDSocialAuthHandler sharedInstance] authWithPlatform:DDSSPlatformWeChat controller:self authHandler:^(DDSSPlatform platform, DDSSAuthState state, id result, NSError *error) {
        switch (state) {
            case DDSSAuthStateBegan: {
                NSLog(@"开始授权");
                break;
            }
            case DDSSAuthStateSuccess: {
                NSLog(@"授权成功:%@",result);
                break;
            }
            case DDSSAuthStateFail: {
                NSLog(@"授权失败:%@",error);
                break;
            }
            case DDSSAuthStateCancel: {
                NSLog(@"取消授权");
                break;
            }
        }
    }];
</code></pre>
