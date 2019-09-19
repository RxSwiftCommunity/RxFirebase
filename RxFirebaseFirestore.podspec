Pod::Spec.new do |s|
    s.name             = 'RxFirebaseFirestore'
    s.version          = '0.3.8'
    s.summary          = 'RxSwift extensions for FirebaseFirestore.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    RxSwift extensions for FirebaseFirestore.
    DESC
    
    s.homepage         = 'https://github.com/RxSwiftCommunity/RxFirebase'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Arnaud Dorgans' => 'arnaud.dorgans@gmail.com' }
    s.source           = { :git => 'https://github.com/RxSwiftCommunity/RxFirebase.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.cocoapods_version = '>= 1.4.0'
    s.ios.deployment_target = '8.0'

    s.static_framework = true
    s.dependency 'RxSwift', '~> 5'
    s.dependency 'RxCocoa', '~> 5'
    s.dependency 'FirebaseFirestore'

    s.source_files = 'Sources/Firestore/**/*'
end
