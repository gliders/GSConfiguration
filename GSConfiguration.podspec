Pod::Spec.new do |s|
  s.name             = "GSConfiguration"
  s.version          = "0.1.0-beta1"
  s.summary          = "A type-safe, generalized configuration library for iOS applications."
  s.description      = <<-DESC
                       A type-safe, generalized configuration library for iOS applications. Supports multiple local
                       plist config files as well as remote JSON configuration services. All configuration files are
                       represented by classes with @dynamic properties similar to Core Data's NSManagedObject.
                       DESC
  s.homepage         = "https://github.com/gliders/GSConfiguration"
  s.license          = 'MIT'
  s.author           = { "Ryan Brignoni" => "castral01@gmail.com" }
  s.source           = { :git => "https://github.com/gliders/GSConfiguration.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/RyanBrignoni'

  s.requires_arc = ['GSConfiguration/*.m', 'GSConfiguration/Transformers/*.m']

  s.platform = :ios, '8.0'

  s.source_files = 'GSConfiguration/**/*.{h,m}'
  s.public_header_files = 'GSConfiguration/**/*.h'
  s.private_header_files = 'GSConfiguration/ThirdParty/**/*.h'
end
