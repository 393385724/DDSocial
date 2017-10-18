# DDSocial
A share auth wheels based on the official library content wecaht sina tencent facebook twitter google mi
#Warning
1、新版TencentSDK不支持模拟器，所以只能使用真机调试
#使用
##使用配置
1、引入类库，必须引入share模块，其他可根据自身app选择性引入<br />
（1）使用pod形式引入
    全部引入
<pre><code>
	pod 'DDSocial' 
</code></pre>
    单个引入
<pre><code>
	pod 'DDSocial/Share' 
	pod 'DDSocial/MI'
	pod 'DDSocial/Wechat'
	pod 'DDSocial/Tencent'
	pod 'DDSocial/Sina'
	pod 'DDSocial/Facebook'
	pod 'DDSocial/Twitter'
	pod 'DDSocial/Google'
	pod 'DDSocial/Line'
	pod 'DDSocial/Instagram'
</code></pre>
（2）使用源文件需要配置类库的Search Paths<br />
选择使用DDSocial目录下的模块Core是必须依赖的模块<br />
Build Settings   ->  Search Paths 两个地方添加  Framework Search Paths 和 Library Search Paths 
2、在AppDelegate.h中实现如下方法<br />
(1)引入头文件
<pre><code>
#import "DDSocialShareHandler.h"
</code></pre>
(2)在应用启动时注册第三方
<pre><code>
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformMI appKey:@"自己申请的key"redirectURL:@"申请时填写的URL"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformWeChat appKey:@"自己申请的key"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformSina appKey:@"自己申请的key"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformQQ appKey:@"自己申请的key"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformFacebook appKey:@"自己申请的key"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformTwitter appKey:@"自己申请的key" appSecret:@"对应的secret"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformGoogle];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformLine];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformInstagram];
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
##分享
2、调用方式<br />
（1）实现分享的protocol<br />
<pre><code>
DDSocialShareTextProtocol//纯文本分享需要实现该协议<br />
DDSocialShareImageProtocol//图片分享需要实现该协议<br />
DDSocialShareWebPageProtocol//web内容分享需要实现该协议<br />
</code></pre>
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
##授权
<pre><code>
[[DDSocialShareHandler sharedInstance] authWithPlatform:DDSSPlatformWeChat authMode:DDSSAuthModeCode controller:self handler:^(DDSSPlatform platform, DDSSAuthState state, DDAuthItem *authItem, NSError *error) {
        switch (state) {
            case DDSSAuthStateBegan: {
                NSLog(@"开始授权");
                break;
            }
            case DDSSAuthStateSuccess: {
                NSLog(@"授权成功：%@",authItem);
                break;
            }
            case DDSSAuthStateFail: {
                NSLog(@"授权失败Error：%@",error);
                break;
            }
            case DDSSAuthStateCancel: {
                NSLog(@"授权取消");
                break;
            }
        }
    }];
</code></pre>

#各个平台配置
###小米开放平台(http://dev.xiaomi.com/index)
1、首先在小米开放平台申请appkey并配置好redirectURL<br />
2、然后在xcode中配置info.plist<br />
   (1)添加NSAppTransportSecurity字段<br />
3、示例代码<br />
<pre><code>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>open.account.xiaomi.com</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
        <key>www.miui.com</key>
        <dict>
          <key>NSIncludesSubdomains</key>
          <true/>
          <key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
          <true/>
        </dict>
    </dict>
</dict>
</code></pre>
###微信开放平台(https://open.weixin.qq.com/)
1、首先在微信开放平台根据自己app的bundleid申请一个appkey<br />
2、然后在xcode中配置info.plist<br />
   （1）添加CFBundleURLTypes<br />
   （2）添加LSApplicationQueriesSchemes白名单<br />
3、示例代码<br />
<pre><code>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>WeChat</string>
        <key>CFBundleURLName</key>
        <string>weixin</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>替换成自己的appkey</string>
        </array>
    </dict>
</array>

<key>LSApplicationQueriesSchemes</key>
    <array>
        <string>weixin</string>
        <string>weichat</string>
    </array>
</code></pre>

###QQ互联(http://connect.qq.com/)
1、首先在QQ互联申请appkey<br />
2、然后在xcode中配置info.plist<br />
   （1）添加CFBundleURLTypes<br />
   （2）添加LSApplicationQueriesSchemes白名单<br />
3、示例代码<br />
<pre><code>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Tencent</string>
        <key>CFBundleURLName</key>
        <string>tencentopenapi</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>替换成自己的appkey</string>
        </array>
    </dict>
</array>

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>mqqOpensdkSSoLogin</string>
    <string>mqqopensdkapiV2</string>
    <string>mqqopensdkapiV3</string>
    <string>mqq</string>
    <string>mqqapi</string>
    <string>wtloginmqq2</string>
    <string>mqzone</string>
    <string>tim</string>
    <string>timapiV1</string>
</array>
</code></pre>
###新浪微博开放平台(http://open.weibo.com/)
1、首先在新浪微博开放平台申请appkey 可以选择配置自己的redirectURL<br />
2、然后在xcode中配置info.plist<br />
   （1）添加CFBundleURLTypes<br />
   （2）添加LSApplicationQueriesSchemes白名单<br />
3、示例代码<br />
<pre><code>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Sina</string>
        <key>CFBundleURLName</key>
        <string>com.weibo</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>替换成自己的appkey</string>
        </array>
    </dict>
</array>

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>sinaweibosso</string>
    <string>sinaweibohdsso</string>
    <string>sinaweibo</string>
    <string>weibosdk</string>
    <string>weibosdk2.5</string>
    <string>sinaweibohd</string>
</array>
</code></pre>
###Google开放平台(https://developers.google.com/identity/sign-in/ios/)
1、首先在google开放平台申请appkey(详细步骤：https://developers.google.com/identity/sign-in/ios/start-integrating#before_you_begin)<br />
2、然后在xcode中配置info.plist<br />
   （1）添加CFBundleURLTypes<br />
3、示例代码<br />
<pre><code>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>google申请的appkey</string>
        </array>
    </dict>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>google申请的bundle</string>
        </array>
    </dict>
</array>
</code></pre>
1、工程的bundleid必须和申请google的完全一致<br />
2、google需要添加他自己生成的info.plist参见文档操作吧，参见连接:https://developers.google.com/identity/sign-in/ios/start-integrating#before_you_begin<br />
###Facebook开放平台(https://developers.facebook.com/) 详情查看(https://developers.facebook.com/docs/ios/getting-started)
1、首先在Facebook开放平台申请appkey<br />
2、然后在xcode中配置info.plist<br />
   （1）添加CFBundleURLTypes<br />
   （2）添加LSApplicationQueriesSchemes白名单<br />
   （3）添加FacebookAppID<br />
   （4）添加FacebookDisplayName<br />
3、示例代码<br />
<pre><code>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>FB</string>
        <key>CFBundleURLName</key>
        <string>facebook</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>替换成自己的appkey</string>
        </array>
    </dict>
</array>

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>fbshareextension</string>
    <string>fbauth2</string>
    <string>fb-messenger-api</string>
    <string>fbapi</string>
</array>
<key>FacebookAppID</key>
<string>125938537776820</string>
<key>FacebookDisplayName</key>
<string>facebook授权页展示的名字</string>
</code></pre>

###Line开放平台(https://developers.line.me/en/docs/line-login/ios/)
1、首先在Line开放平台申请appkey(详细步骤：https://developers.line.me/en/docs/line-login/ios/integrate-line-login/)<br />
2、然后在xcode中配置info.plist<br />
   （1）添加CFBundleURLTypes<br />
   （2）添加LSApplicationQueriesSchemes白名单<br />
   （3）添加LineSDKConfig<br />
3、示例代码<br />
<pre><code>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>line3rdp.$(PRODUCT_BUNDLE_IDENTIFIER)</string>
        </array>
    </dict>
</array>
</code></pre>
<pre><code>
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>lineauth</string>
    <string>line3rdp.$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <string>line</string>
</array>
</dict>
</code></pre>
<pre><code>
<key>LineSDKConfig</key>
<dict>
    <key>ChannelID</key>
    <string>自己申请的LineID</string>
</dict>  
</code></pre>
###Instagram开放平台(目前只支持图片分享，暂不支持授权)(//https://www.instagram.com/developer/mobile-sharing/iphone-hooks/)
1、在xcode中配置info.plist<br />
   （1）添加LSApplicationQueriesSchemes白名单<br />
3、示例代码<br />
<pre><code>
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>instagram</string>
</array>
</dict>

