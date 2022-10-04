Pod::Spec.new do |spec|
  
  spec.name         = "MATLog"
  spec.version      = "0.0.1"
  spec.summary      = "基于CocoaLumberjack的封装，方便使用，以及增加了一些功能。"
  spec.homepage     = "https://github.com/xq-120/MATLog"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "xq" => "1204556447@qq.com" }

  spec.platform     = :ios, "10.0"

  spec.source       = { :git => "https://github.com/xq-120/MATLog.git", :tag => "#{spec.version}" }

  spec.source_files  = "MATLog/Classes/**/*"

  spec.frameworks = "Foundation", "UIKit"

  spec.requires_arc = true
  spec.dependency "CocoaLumberjack", "~> 3.7.4"

end
