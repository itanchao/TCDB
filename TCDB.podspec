Pod::Spec.new do |s|
  s.name             = 'TCDB'
  s.version          = '0.1.0'
  s.summary          = 'TCDB 是一个简单的SQLITE库.'

  s.description      = <<-DESC
    TCDB是一个基于Swift3.0写的一个SQLITE库
                       DESC

  s.homepage         = 'https://github.com/itanchao/TCDB'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'itanchao' => 'itanchao@gmail.com' }
  s.source           = { :git => 'https://github.com/itanchao/TCDB.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TCDB/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TCDB' => ['TCDB/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
