Pod::Spec.new do |spec|
  
  spec.name         = "MATLog"
  spec.version      = "0.2.0"
  spec.summary      = "基于CocoaLumberjack的封装，方便使用，以及增加了一些功能。"
  spec.homepage     = "https://github.com/xq-120/MATLog"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "xq" => "1204556447@qq.com" }

  spec.platform     = :ios, "11.0"

  spec.source       = { :git => "https://github.com/xq-120/MATLog.git", :tag => "#{spec.version}" }

  spec.frameworks = "Foundation", "UIKit"
  
  spec.swift_versions = ['5.5', '5.6', '5.7']
  spec.requires_arc = true
  spec.dependency "CocoaLumberjack", "~> 3.7.4", :modular_headers => true
  spec.dependency "WCDB.objc", "~> 2.1.10", :modular_headers => true
  
  spec.default_subspecs = 'Core'

  spec.subspec 'Core' do |ss|
    ss.source_files = 'Sources/MATLog/**/*.{h,m,mm}'
    ss.private_header_files = 'Sources/MATLog/*WCTTableCoding.{h}' #控制OC头文件访问权限的有private、project、public三种。默认public
  end

  spec.subspec 'Swift' do |ss|
    ss.dependency 'MATLog/Core'
    ss.source_files = 'Sources/MATLogSwift/**/*.{swift,h,mm}'
  end
end
