Pod::Spec.new do |s|  
  s.name             = "DDSocial"  
  s.version          = "1.4.0"  
  s.summary          = "A share auth wheels based on the official library content wecaht sina tencent facebook twitter google mi"  
  s.homepage         = "https://github.com/393385724/DDSocial"  
  s.license          = 'MIT'  
  s.author           = { "llg" => "393385724@qq.com" }  
  s.source           = { :git => "https://github.com/393385724/DDSocial.git", :tag => s.version.to_s }  
  
  s.platform     = :ios, '8.0'  
  s.requires_arc = true 

  s.subspec 'Core' do |core|
    core.source_files  = 'DDSocial/Core/*.{h,m}'
    core.frameworks    = 'Foundation', 'UIKit', 'Accelerate'
  end

  s.subspec 'Tencent' do |tencent|
    tencent.source_files = 'DDSocial/Tencent/Handler/*.{h,m}'
    tencent.ios.vendored_frameworks = 'DDSocial/Tencent/TencentSDK/*.framework'
    tencent.libraries = 'z', 'sqlite3','stdc++','iconv'
    tencent.frameworks = 'SystemConfiguration','CoreGraphics', 'CoreTelephony', 'Security'
    tencent.dependency 'DDSocial/Core'
  end

  s.subspec 'Wechat' do |wechat|
    wechat.source_files = 'DDSocial/Wechat/Handler/*.{h,m}','DDSocial/Wechat/WeChatSDK/*.h'
    wechat.ios.vendored_libraries = 'DDSocial/Wechat/WeChatSDK/*.a'
    wechat.libraries = 'z', 'sqlite3','stdc++'
    wechat.frameworks = 'SystemConfiguration','CoreTelephony'
    wechat.dependency 'DDSocial/Core'
  end

  s.subspec 'Sina' do |sina|
	sina.source_files = 'DDSocial/Sina/*.{h,m}','DDSocial/Sina/libWeiboSDK/*.{h,m}'
	sina.resource     = 'DDSocial/Sina/libWeiboSDK/WeiboSDK.bundle'
	sina.ios.vendored_libraries  = 'DDSocial/Sina/libWeiboSDK/libWeiboSDK.a'
	sina.frameworks   = 'ImageIO', 'CoreText', 'QuartzCore', 'SystemConfiguration','Security', 'CoreGraphics','CoreTelephony'
	sina.libraries = 'z', 'sqlite3'
    sina.dependency 'DDSocial/Core'
  end

  s.subspec 'Facebook' do |facebook|
    facebook.source_files = 'DDSocial/Facebook/*.{h,m}'
    facebook.dependency 'FBSDKLoginKit'
    facebook.dependency 'FBSDKShareKit'
    facebook.dependency 'DDSocial/Core'
  end

  s.subspec 'Twitter' do |twitter|
    twitter.source_files = 'DDSocial/Twitter/*.{h,m}'
    twitter.dependency 'DDSocial/Core'
  end

  s.subspec 'MI' do |mi|
    mi.source_files = 'DDSocial/MI/Handler/*.{h,m}'
	mi.user_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
    mi.ios.vendored_frameworks = 'DDSocial/MI/MiSDK/*.framework'
    mi.resource = "DDSocial/MI/MiSDK/*.bundle"
    mi.dependency 'DDSocial/Core'
  end

  s.subspec 'Google' do |google|
    google.source_files = 'DDSocial/Google/*.{h,m}'
    google.dependency 'Google/SignIn'
    google.dependency 'DDSocial/Core'
  end

  s.subspec 'Share' do |share|
    share.source_files  = 'DDSocial/Handler/DDSocialShareHandler.{h,m}'
    share.dependency 'DDSocial/Core'
  end
end  
