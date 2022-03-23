#
#  Be sure to run `pod spec lint Test.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = 'UdeskAVSSDK'
  s.version      = '1.0.0'
  s.license      = 'MIT'
  s.summary      = 'LocalLib.'
  s.description  = <<-DESC
    UdeskAVS local Warehouse of po in LocalLib.
                   DESC
  s.author       = {'zhangshuangyi ' => 'zhangshuangyi@udesk.cn'}
  s.homepage     = "{ :git => "", :tag => "#{s.version}" }"
  s.source       = { :git => "", :tag => "#{s.version}" }
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.source_files = 'UdeskAVSSDK/UIKit/*.{h,m}'
  s.public_header_files = 'UdeskAVSSDK/UIKit*.{h}'

  s.xcconfig     = {'OTHER_LDFLAGS' => '-ObjC', 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2'}
  
  s.subspec 'Framework' do |ss|
    ss.source_files = "UdeskAVSSDK/UdeskAVSSDK.framework/Headers/*",'UdeskAVS/*.framework'
    ss.vendored_frameworks = 'UdeskAVSSDK/*.framework'
    ss.public_header_files = "UdeskAVSSDK/UdeskAVSSDK.framework/Headers/*.h"
  end

  s.subspec 'UIKit' do |ss|
    ss.source_files = 'UdeskAVSSDK/UIKit/**/*.{h,m}'
    ss.resource     = 'UdeskAVSSDK/UIKit/Resources/UdeskAVSBundle.bundle'
    ss.public_header_files = 'UdeskAVSSDK/UIKit/**/*.{h}'
    ss.frameworks = 'Accelerate', 'OpenAL'
    ss.libraries  = 'z', 'c++', 'resolv', 'sqlite3'
    ss.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }

    ss.dependency 'YYText', '~> 1.0.7'
    ss.dependency 'SDWebImage', '5.11.1'
    ss.dependency 'TXLiteAVSDK_TRTC', '8.7.10102'
    ss.dependency 'UdeskAVSSDK/Framework'
    
    
  
  end

end

  
