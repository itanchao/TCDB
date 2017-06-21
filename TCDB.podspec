
Pod::Spec.new do |s|
  s.name             = 'TCDB'
  s.version          = '0.1.0'
  s.summary          = '一个简单的SQLITE库.'
  s.description      = <<-DESC
TCDB是一个简单的Swift版本的SQLITE库
                       DESC

  s.homepage         = 'https://github.com/itanchao/TCDB'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'itanchao' => 'itanchao@gmail.com' }
  s.source           = { :git => 'https://github.com/itanchao/TCDB.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'TCDB/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TCDB' => ['TCDB/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
