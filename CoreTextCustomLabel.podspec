
Pod::Spec.new do |s|

  s.name         = "CoreTextCustomLabel"
  s.version      = "0.1.0"
  s.summary      = "An iOS library that lets you get started rendering basic Core Text in your apps."

  s.description  = <<-DESC
An iOS library that lets you get started rendering basic Core Text in your apps. It's essentially a subclass of UILabel that allows you to set kerning, line height, & multiple fonts.
                   DESC

  s.homepage     = "https://github.com/rhaining/Core-Text-Label"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  s.license      = "Apache License, Version 2.0"

  s.author             = "Robert Haining"
  s.social_media_url   = "http://twitter.com/tolar"

  s.platform     = :ios, "6.0"

  s.source       = { :git => "git@github.com:rhaining/Core-Text-Label.git", :tag => "0.1.0" }

  s.source_files  = "src", "src/**/*.{h,m}"

  s.frameworks = "CoreText", "UIKit", "Foundation", "CoreGraphics"

  s.requires_arc = true

end
