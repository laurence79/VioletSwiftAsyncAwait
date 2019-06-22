#
# Be sure to run `pod lib lint VioletSwiftAsyncAwait.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VioletSwiftAsyncAwait'
  s.version          = '0.1.0'
  s.summary          = 'Provides utilities for writing asynchronous code using async/await constructs.'
  s.swift_version    = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
VioletSwiftAsyncAwait allows you to write asynchronous code as if it were synchronous. Similar to the async and await
keywords in C# and javascript (among others). Under the hood it uses dispatch queues and semaphores.
                       DESC

  s.homepage         = 'https://github.com/laurence79/VioletSwiftAsyncAwait'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'laurence79' => 'laurence@hartgill.co.uk' }
  s.source           = { :git => 'https://github.com/laurence79/VioletSwiftAsyncAwait.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'VioletSwiftAsyncAwait/Classes/**/*'
end
