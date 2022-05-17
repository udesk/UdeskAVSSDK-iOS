#
#  Be sure to run `pod spec lint Test.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = 'UdeskAVSSDK'
  s.version      = '1.1.0'
  s.license      = 'MIT'
  s.summary      = 'lib.'
  s.description  = <<-DESC
  UdeskAVSSDK local Warehouse of po in LocalLib.
                   DESC
  s.author       = {'zhangshuangyi ' => 'zhangshuangyi@udesk.cn'}
  s.homepage     = '{ :git => "", :tag => "#{s.version}" }'
  s.source       = { :git => '', :tag => '#{s.version}' }
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.xcconfig     = {'OTHER_LDFLAGS' => '-ObjC', 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2'}
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'i386 x86_64 armv7 arm64' }

  s.subspec 'SDK' do |ss|
    ss.source_files = 'UdeskAVSSDK/SDK/**/*.h'
    ss.vendored_libraries = 'UdeskAVSSDK/SDK/libUdeskAVS.a'
    ss.public_header_files = 'UdeskAVSSDK/SDK/**/*.h'
  end
  
  s.static_framework = true
  s.source_files = 'UdeskAVSSDK/UIKit/*.{h,m}'
  s.public_header_files = 'UdeskAVSSDK/UIKit*.{h}'
  s.subspec 'AVSKit' do |ss|
    ss.source_files = 'UdeskAVSSDK/UIKit/**/*.{h,m}'
    ss.resource     = 'UdeskAVSSDK/UIKit/Resources/UdeskAVSBundle.bundle'
    ss.public_header_files = 'UdeskAVSSDK/UIKit/**/*.{h}'
    ss.frameworks = 'Accelerate', 'OpenAL'
    ss.libraries  = 'z', 'c++', 'resolv', 'sqlite3'
    ss.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
    
    ss.dependency 'UdeskAVSSDK/SDK'
    ss.dependency 'YYText', '~> 1.0.7'
    ss.dependency 'SDWebImage', '~>5.11.1'
    ss.dependency 'MJRefresh', '~> 3.7.5'
    ss.dependency 'TXLiteAVSDK_TRTC', '8.7.10102'

  end

  
end

  
