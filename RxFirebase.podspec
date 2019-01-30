#
# Be sure to run `pod lib lint RxFirebase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'RxFirebase'
    s.version          = '0.2.6'
    s.summary          = 'RxSwift extensions for Firebase.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    RxSwift extensions for Firebase.
    Including for now Database, Firestore, RemoteConfig, Storage, Functions
    DESC
    
    s.homepage         = 'https://github.com/RxSwiftCommunity/RxFirebase'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Arnaud Dorgans' => 'arnaud.dorgans@gmail.com' }
    s.source           = { :git => 'https://github.com/RxSwiftCommunity/RxFirebase.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.cocoapods_version = '>= 1.4.0'
    s.swift_version = '4.0'
    s.ios.deployment_target = '8.0'
    s.tvos.deployment_target = '10.0'
    s.osx.deployment_target = '10.10'

    s.static_framework = true
    s.dependency 'RxSwift', '~> 4'
    s.dependency 'RxCocoa', '~> 4'
    
    s.subspec 'Firestore' do |firestore|
        firestore.source_files = 'Sources/Firestore/**/*'
        firestore.dependency 'FirebaseFirestore', '~> 1'
    end
    s.subspec 'RemoteConfig' do |remote|
        remote.source_files = 'Sources/RemoteConfig/**/*'
        remote.dependency 'FirebaseRemoteConfig', '~> 3'
    end
    s.subspec 'Database' do |database|
        database.source_files = 'Sources/Database/**/*'
        database.dependency 'FirebaseDatabase', '~> 5'
    end
    s.subspec 'Storage' do |storage|
        storage.source_files = 'Sources/Storage/**/*'
        storage.dependency 'FirebaseStorage', '~> 3'
    end
    s.subspec 'Functions' do |functions|
        functions.source_files = 'Sources/Functions/**/*'
        functions.dependency 'FirebaseFunctions', '~> 2'
    end
    s.subspec 'Auth' do |auth|
        auth.source_files = 'Sources/Auth/**/*'
        auth.dependency 'FirebaseAuth', '~> 5'
        auth.dependency 'FirebaseCore', '~> 5.1'
    end
end
