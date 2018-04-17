Pod::Spec.new do |s|

  s.name         = "TDAppMonitorKit"
  s.version      = "0.0.2"
  s.summary      = "性能监测"
  s.homepage     = "https://github.com/BeckWang0912/TDAppMonitorKit"
  s.license      = { :type => "MIT", :file => "LICENSE" } 
  s.description  = <<-DESC 
                        TDAppMonitorKit 是一个性能监测工具，集成了UI、CPU、Memory检测分析
                   DESC
  s.author       = { "wangzhitao" => "2067431781@qq.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "git@github.com:BeckWang0912/TDAppMonitorKit.git", :tag => 'v'+s.version.to_s}
  s.source_files = ['TDAppMonitorKit/Fluency/', 'TDAppMonitorKit/FPS/', 'TDAppMonitorKit/Resource/','TDAppMonitorKit/Tools/**/*.{h,m}']
  s.requires_arc = true

end