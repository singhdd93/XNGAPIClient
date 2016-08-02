Pod::Spec.new do |s|
  s.name = "XNGAPIClient"
  s.version = "2.2.0"
  s.license = 'MIT'
  s.ios.deployment_target = '6.0'
  s.summary = 'The official Objective-C client for the XING API'
  s.author  = {
    'XING iOS Team' => 'iphonedev@xing.com'
  }
  s.source = {
    :git => 'https://github.com/xing/XNGAPIClient.git',
    :tag => s.version.to_s
  }
  s.requires_arc = true
  s.homepage = 'https://www.xing.com'
  s.default_subspec = 'Core'

  s.subspec 'Core' do |sp|
    sp.source_files = 'XNGAPIClient/*.{h,m}'
    sp.dependency 'SAMKeychain', '~> 1.5.0'
    sp.dependency 'XNGOAuth1Client', '~> 2.0.0'
    sp.dependency 'AFNetworking', '= 2.5.4'
    sp.frameworks = 'Security','SystemConfiguration', 'UIKit'
  end

  s.subspec 'NSDictionary-Typecheck' do |sp|
    sp.source_files = 'XNGAPIClient/NSDictionary+Typecheck.{h,m}'
  end
end
