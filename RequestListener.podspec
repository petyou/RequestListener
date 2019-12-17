Pod::Spec.new do |spec|

  spec.name         = "RequestListener"
  spec.version      = "0.0.3"
  spec.summary      = "A request listener for iOS app"
  spec.homepage     = "https://github.com/petyou/RequestListener"
  spec.license      = "MIT"
  spec.author       = { "petyou" => "812607796@qq.com" }
  spec.platform     = :ios, "8.0"
  spec.source       = { :git => "https://github.com/petyou/RequestListener.git", :tag => spec.version }
  spec.source_files = "RequestListener/**/*.{h,m}"
  spec.requires_arc = true
end
