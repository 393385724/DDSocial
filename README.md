# DDSocial
A share auth wheels based on the official library content wecaht sina tencent facebook twitter google mi
# Warning
1、新版TencentSDK不支持模拟器，所以只能使用真机调试
# 使用 
## 使用配置 
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
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformMI appKey:@"自己申请的key或appID根据三方平台决定"redirectURL:@"申请时填写的URL"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformWeChat appKey:@"自己申请的key或appID根据三方平台决定"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformSina appKey:@"自己申请的key或appID根据三方平台决定"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformQQ appKey:@"自己申请的key或appID根据三方平台决定"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformFacebook appKey:@"自己申请的key或appID根据三方平台决定"];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformTwitter appKey:@"自己申请的key或appID根据三方平台决定" appSecret:@"对应的secret"];
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
## 分享
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
## 授权
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

# 各个平台配置
### 小米开放平台(http://dev.xiaomi.com/index)
1、首先在小米开放平台申请appkey并配置好redirectURL<br />
2、然后在xcode中配置info.plist<br />
   （1）添加CFBundleURLTypes<br />
   (2)添加NSAppTransportSecurity字段<br />
3、示例代码<br />
<pre><code>
&lt;dict>
	&lt;key>CFBundleTypeRole&lt;/key>
	&lt;string>MI&lt;/string>
	&lt;key>CFBundleURLName&lt;/key>
	&lt;string>xiaomi&lt;/string>
	&lt;key>CFBundleURLSchemes&lt;/key>
	&lt;array>
		&lt;string>miXXXXXXXXX&lt;/string>
	&lt;/array>
&lt;/dict>

&lt;key>NSAppTransportSecurity&lt;/key>
&lt;dict>
    &lt;key>NSAllowsArbitraryLoads&lt;/key>
    &lt;true/>
    &lt;key>NSExceptionDomains&lt;/key>
    &lt;dict>
        &lt;key>open.account.xiaomi.com&lt;/key>
        &lt;dict>
            &lt;key>NSExceptionAllowsInsecureHTTPLoads&lt;/key>
            &lt;true/>
        &lt;/dict>
        &lt;key>www.miui.com&lt;/key>
        &lt;dict>
          &lt;key>NSIncludesSubdomains&lt;/key>
          &lt;true/>
          &lt;key>NSThirdPartyExceptionAllowsInsecureHTTPLoads&lt;/key>
          &lt;true/>
        &lt;/dict>
    &lt;/dict>
&lt;/dict>
</code></pre>
### 微信开放平台(https://open.weixin.qq.com/)
1、首先在微信开放平台根据自己app的bundleid申请一个appkey<br />
2、然后在xcode中配置info.plist<br />
   （1）添加CFBundleURLTypes<br />
   （2）添加LSApplicationQueriesSchemes白名单<br />
3、示例代码<br />
<pre><code>
&lt;key>CFBundleURLTypes&lt;/key>
&lt;array>
    &lt;dict>
        &lt;key>CFBundleTypeRole&lt;/key>
        &lt;string>WeChat&lt;/string>
        &lt;key>CFBundleURLName&lt;/key>
        &lt;string>weixin&lt;/string>
        &lt;key>CFBundleURLSchemes&lt;/key>
        &lt;array>
            &lt;string>替换成自己的appkey&lt;/string>
        &lt;/array>
    &lt;/dict>
&lt;/array>

&lt;key>LSApplicationQueriesSchemes&lt;/key>
    &lt;array>
        &lt;string>weixin&lt;/string>
        &lt;string>weichat&lt;/string>
    &lt;/array>
</code></pre>

### QQ互联(http://connect.qq.com/)
1、首先在QQ互联申请appkey<br />
2、然后在xcode中配置info.plist<br />
   （1）添加CFBundleURLTypes<br />
   （2）添加LSApplicationQueriesSchemes白名单<br />
3、示例代码<br />
<pre><code>
&lt;key>CFBundleURLTypes&lt;/key>
&lt;array>
    &lt;dict>
        &lt;key>CFBundleTypeRole&lt;/key>
        &lt;string>Tencent&lt;/string>
        &lt;key>CFBundleURLName&lt;/key>
        &lt;string>tencentopenapi&lt;/string>
        &lt;key>CFBundleURLSchemes&lt;/key>
        &lt;array>
            &lt;string>替换成自己的appkey&lt;/string>
        &lt;/array>
    &lt;/dict>
&lt;/array>

&lt;key>LSApplicationQueriesSchemes&lt;/key>
&lt;array>
    &lt;string>mqqOpensdkSSoLogin&lt;/string>
    &lt;string>mqqopensdkapiV2&lt;/string>
    &lt;string>mqqopensdkapiV3&lt;/string>
    &lt;string>mqq&lt;/string>
    &lt;string>mqqapi&lt;/string>
    &lt;string>wtloginmqq2&lt;/string>
    &lt;string>mqzone&lt;/string>
    &lt;string>tim&lt;/string>
    &lt;string>timapiV1&lt;/string>
&lt;/array>
</code></pre>
### 新浪微博开放平台(http://open.weibo.com/)
1、首先在新浪微博开放平台申请appkey 可以选择配置自己的redirectURL<br />
2、然后在xcode中配置info.plist<br />
   （1）添加CFBundleURLTypes<br />
   （2）添加LSApplicationQueriesSchemes白名单<br />
3、示例代码<br />
<pre><code>
&lt;key>CFBundleURLTypes&lt;/key>
&lt;array>
    &lt;dict>
        &lt;key>CFBundleTypeRole&lt;/key>
        &lt;string>Sina&lt;/string>
        &lt;key>CFBundleURLName&lt;/key>
        &lt;string>com.weibo&lt;/string>
        &lt;key>CFBundleURLSchemes&lt;/key>
        &lt;array>
            &lt;string>替换成自己的appkey&lt;/string>
        &lt;/array>
    &lt;/dict>
&lt;/array>

&lt;key>LSApplicationQueriesSchemes&lt;/key>
&lt;array>
    &lt;string>sinaweibosso&lt;/string>
    &lt;string>sinaweibohdsso&lt;/string>
    &lt;string>sinaweibo&lt;/string>
    &lt;string>weibosdk&lt;/string>
    &lt;string>weibosdk2.5&lt;/string>
    &lt;string>sinaweibohd&lt;/string>
&lt;/array>
</code></pre>
### Google开放平台(https://developers.google.com/identity/sign-in/ios/) <br />
1、首先在google开放平台申请appkey(详细步骤：https://developers.google.com/identity/sign-in/ios/start-integrating#before_you_begin)<br />
2、然后在xcode中配置info.plist<br />
   （1）添加CFBundleURLTypes<br />
3、示例代码<br />
<pre><code>
&lt;key>CFBundleURLTypes&lt;/key>
&lt;array>
    &lt;dict>
        &lt;key>CFBundleTypeRole&lt;/key>
        &lt;string>Editor&lt;/string>
        &lt;key>CFBundleURLSchemes&lt;/key>
        &lt;array>
            &lt;string>google申请的appkey&lt;/string>
        &lt;/array>
    &lt;/dict>
    &lt;dict>
        &lt;key>CFBundleTypeRole&lt;/key>
        &lt;string>Editor&lt;/string>
        &lt;key>CFBundleURLSchemes&lt;/key>
        &lt;array>
            &lt;string>google申请的bundle&lt;/string>
        &lt;/array>
    &lt;/dict>
&lt;/array>
</code></pre>
1、工程的bundleid必须和申请google的完全一致<br />
2、google需要添加他自己生成的info.plist参见文档操作吧，参见连接:https://developers.google.com/identity/sign-in/ios/start-integrating#before_you_begin<br />
### Facebook开放平台(https://developers.facebook.com/) 详情查看(https://developers.facebook.com/docs/ios/getting-started) <br />
1、首先在Facebook开放平台申请appkey<br />
2、然后在xcode中配置info.plist<br />
   （1）添加CFBundleURLTypes<br />
   （2）添加LSApplicationQueriesSchemes白名单<br />
   （3）添加FacebookAppID<br />
   （4）添加FacebookDisplayName<br />
3、示例代码<br />
<pre><code>
&lt;key>CFBundleURLTypes&lt;/key>
&lt;array>
    &lt;dict>
        &lt;key>CFBundleTypeRole&lt;/key>
        &lt;string>FB&lt;/string>
        &lt;key>CFBundleURLName&lt;/key>
        &lt;string>facebook&lt;/string>
        &lt;key>CFBundleURLSchemes&lt;/key>
        &lt;array>
            &lt;string>替换成自己的appkey&lt;/string>
        &lt;/array>
    &lt;/dict>
&lt;/array>

&lt;key>LSApplicationQueriesSchemes&lt;/key>
&lt;array>
    &lt;string>fbshareextension&lt;/string>
    &lt;string>fbauth2&lt;/string>
    &lt;string>fb-messenger-api&lt;/string>
    &lt;string>fbapi&lt;/string>
&lt;/array>
&lt;key>FacebookAppID&lt;/key>
&lt;string>125938537776820&lt;/string>
&lt;key>FacebookDisplayName&lt;/key>
&lt;string>facebook授权页展示的名字&lt;/string>
</code></pre>

### Line开放平台(https://developers.line.me/en/docs/line-login/ios/)<br />
1、首先在Line开放平台申请appkey(详细步骤：https://developers.line.me/en/docs/line-login/ios/integrate-line-login/) <br />
2、然后在xcode中配置info.plist<br />
   （1）添加CFBundleURLTypes<br />
   （2）添加LSApplicationQueriesSchemes白名单<br />
   （3）添加LineSDKConfig<br />
3、示例代码<br />
<pre><code>
&lt;key>CFBundleURLTypes&lt;/key>
&lt;array>
    &lt;dict>
        &lt;key>CFBundleTypeRole&lt;/key>
        &lt;string>Editor&lt;/string>
        &lt;key>CFBundleURLSchemes&lt;/key>
        &lt;array>
            &lt;string>line3rdp.$(PRODUCT_BUNDLE_IDENTIFIER)&lt;/string>
        &lt;/array>
    &lt;/dict>
&lt;/array>
</code></pre>
<pre><code>
&lt;key>LSApplicationQueriesSchemes&lt;/key>
&lt;array>
    &lt;string>lineauth&lt;/string>
    &lt;string>line3rdp.$(PRODUCT_BUNDLE_IDENTIFIER)&lt;/string>
    &lt;string>line&lt;/string>
&lt;/array>
&lt;/dict>
</code></pre>
<pre><code>
&lt;key>LineSDKConfig&lt;/key>
&lt;dict>
    &lt;key>ChannelID&lt;/key>
 	&lt;string>自己申请的LineID&lt;/string>
&lt;/dict>  
</code></pre>
### Instagram开放平台(目前只支持图片分享，暂不支持授权)(//https://www.instagram.com/developer/mobile-sharing/iphone-hooks/) <br />
1、在xcode中配置info.plist<br />
   （1）添加LSApplicationQueriesSchemes白名单<br />
3、示例代码<br />
<pre><code>
&lt;key>LSApplicationQueriesSchemes&lt;/key>
&lt;array>
    &lt;string>instagram&lt;/string>
&lt;/array>
&lt;/dict>

