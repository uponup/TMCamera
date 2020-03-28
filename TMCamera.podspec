#
# Be sure to run `pod lib lint TMCamera.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TMCamera'
  s.version          = '0.2.2'
  s.summary          = '简单实用的相机，可裁剪照片'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
实现了相机功能；从相册获取照片；裁剪照片功能；
                       DESC

  s.homepage         = 'https://github.com/uponup/TMCamera'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'uponup' => '1030360567@qq.com' }
  s.source           = { :git => 'https://github.com/uponup/TMCamera.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.3'

  s.source_files = 'TMCamera/Classes/**/*'
  
#   s.resource_bundles = {
#     'TMCamera' => ['TMCamera/Assets/*']
#   }

  # s.public_header_files = 'Pod/Classes/**/*.xib'
  # s.frameworks = 'AVFoundation'
   s.dependency 'PureLayout'
end
