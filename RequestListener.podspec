Pod::Spec.new do |spec|

  spec.name         = "RequestListener"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of RequestListener."
  spec.description  = "A requeset listener for iOS app"
  spec.homepage     = "https://github.com/petyou/RequestListener"
  spec.license      = "MIT"
  spec.author       = { "petyou" => "812607796@qq.com" }
  spec.platform     = :ios, "8.0"
  spec.source       = { :git => "https://github.com/petyou/RequestListener", :tag => "#{spec.version}" }
  spec.source_files = "SGQRequestListenerDemo/RequestListener"
  spec.requires_arc = true
end
