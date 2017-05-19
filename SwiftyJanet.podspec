Pod::Spec.new do |s|
  s.name         = "SwiftyJanet"
  s.version      = "0.1"
  s.summary      = "Swift version of Janet framework"
  s.description  = "Swift version of Janet framework for command-based reactive architecture"
  s.homepage     = "https://github.com/fuzza/SwiftyJanet"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Alex Faizullov" => "alex.faizullov@gmail.com" }
  s.social_media_url   = ""
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/fuzza/SwiftyJanet.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
  s.dependency "RxSwift", "~> 3.0"
end
