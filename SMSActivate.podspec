#
# Be sure to run `pod lib lint SMSActivate.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SMSActivate'
  s.version          = '0.1.0'
  s.summary          = 'SMS Activate iOS SDK'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/alperengezgin/smsactivate'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alperen Polat GEZGIN' => 'alperengezgin@gmail.com' }
  s.source           = { :git => 'https://github.com/alperengezgin/smsactivate.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/alperengezgin'

  s.ios.deployment_target = '13.0'

  s.source_files = 'SMSActivate/Classes/**/*'
  
  s.resource_bundles = {
      'SMSActivate' => ['SMSActivate/Assets/*.{png,json}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'Firebase/Database'
  s.dependency 'Firebase/Firestore'
  s.dependency 'Alamofire'
  s.dependency 'FlagKit'
  s.dependency 'SwiftyUserDefaults'
end
