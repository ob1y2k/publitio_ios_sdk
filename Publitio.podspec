Pod::Spec.new do |s|

s.name         = "Publitio"
s.version      = "1.0.0"
s.summary      = "Publitio is Video and Image API built for developers by developers."
s.description  =  <<-DESC

Publitio is a cloud service that offers a solution to a web application's entire image and video management pipeline.

Easily upload images and videos to the cloud. Automatically perform smart image resizing, cropping and conversion without installing any complex software. Images and Videos are seamlessly delivered through a fast CDN, and much much more.

Publitio offers comprehensive APIs and administration capabilities and is easy to integrate with any web application, existing or new.

Publitio provides URL and HTTP based APIs that can be easily integrated with any Web development framework. Also it includes mobile SDK's for Android and IOS
			DESC


s.homepage     = "https://publit.io"
s.author            = { 'Publitio' => 'info@publit.io' }
s.license      = "MIT"
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/ob1y2k/publitio_ios_sdk.git", :tag => "1.0.0" }
#s.source_files = "Publitio/**/*"
s.vendored_frameworks = "Publitio.framework"
s.swift_version = "4.1" 

end