Pod::Spec.new do |s|

  s.name         = "JYDataBase"
  s.version      = "1.0.5"
  s.summary      = "对FMDB的轻量级封装，帮助快速创建管理移动端数据库."

  s.homepage     = "https://github.com/weijingyunIOS/JYDatabase"

  s.license      = "MIT"

  s.author             = { "魏景云" => "wei_jingyun@outlook.com" }
  s.platform     = :ios
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/weijingyunIOS/JYDatabase.git",:branch => "master", :tag => "1.0.5" }
  s.requires_arc = true
  s.source_files  = "JYDatabase - OC/JYDatabase - OC/JYDatabase/*.{h,m}"
  s.public_header_files = "JYDatabase - OC/JYDatabase - OC/JYDatabase/*.h"

  s.framework  = "UIKit","Foundation"

  s.dependency 'FMDB', '~> 2.6.2'

end
