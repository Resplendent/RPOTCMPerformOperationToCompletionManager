#
# Be sure to run `pod lib lint RPOTCMPerformOperationToCompletionManager.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RPOTCMPerformOperationToCompletionManager"
  s.version          = "0.2.1"
  s.summary          = "Asynchronously performs operations while observing for reachability."
# s.description      = <<-DESC
#                        An optional longer description of RPOTCMPerformOperationToCompletionManager
#
#                        * Markdown format.
#                        * Don't worry about the indent, we strip it!
#                        DESC
  s.homepage         = "https://github.com/Resplendent/RPOTCMPerformOperationToCompletionManager.git"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.authors          = {
							"Benjamin Maer" => "ben@resplendent.co",
							"Richard Reitzfeld" => "richie.reitzfeld@gmail.com"
}
  s.source           = { :git => "https://github.com/Resplendent/RPOTCMPerformOperationToCompletionManager.git", :tag => "v#{s.version}"}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'ResplendentUtilities', '~> 0.5.0'
  s.dependency 'FXReachability', '~> 1.3.2'
end
