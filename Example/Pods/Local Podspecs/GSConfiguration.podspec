Pod::Spec.new do |s|
  s.name             = "GSConfiguration"
  s.version          = "0.1.0"
  s.summary          = "A short description of GSConfiguration."
  s.description      = <<-DESC
                       A generalized configuration library for iOS applications.
                       DESC
  s.homepage         = "https://github.com///gliders/GSConfiguration"
  s.license          = 'MIT'
  s.author           = { "Ryan Brignoni" => "castral01@gmail.com" }
  s.source           = { :git => "https://github.com/gliderss/GSConfiguration.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/RyanBrignoni'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'

  s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'MAObjCRuntime', '~> 0.0.1'
end
