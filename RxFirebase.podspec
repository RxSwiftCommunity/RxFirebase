#
# Be sure to run `pod lib lint RxFirebase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxFirebase'
  s.version          = '0.1.0'
  s.summary          = 'RxSwift extensions for Firebase.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
RxSwift extensions for Firebase.
Including for now FirebaseCore
                       DESC

  s.homepage         = 'https://github.com/arnauddorgans/RxFirebase'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Arnaud Dorgans' => 'arnaud.dorgans@gmail.com' }
  s.source           = { :git => 'https://github.com/arnauddorgans/RxFirebase.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

swift_version = 4.1
  s.ios.deployment_target = '8.0'
    s.static_framework = true
    s.dependency 'RxSwift', '~> 4'
    s.dependency 'RxCocoa', '~> 4'
    s.dependency 'FirebaseCore', '~> 4'

#s.subspec 'Core' do |core|
#core.source_files = 'RxFirebase/Classes/Core/**/*'
#end
#s.subspec 'Database' do |database|
#database.source_files = 'RxFirebase/Classes/Database/**/*'
#database.dependency 'FirebaseDatabase', '~> 4'
#end
    s.subspec 'Firestore' do |firestore|
        firestore.source_files = 'RxFirebase/Classes/Firestore/**/*'
        firestore.dependency 'FirebaseFirestore', '~> 0'
    end
  
end
