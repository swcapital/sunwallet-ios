platform :ios, '14.0'
use_frameworks!
target 'SunWallet' do 
	pod 'MagicSDK'
	pod 'MagicExt-OAuth'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
   
    # overwrite web3 packages to change deployment target to 9.0
    if ['Web3'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '5.3'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end
end

#https://github.com/AppPear/ChartViewV2Demo
#https://github.com/CSolanaM/SkeletonUI
#https://github.com/exyte/ActivityIndicatorView
#https://github.com/exyte/PopupView
#https://github.com/alexejn/TypeYouCard
#https://www.hackingwithswift.com/100
#https://github.com/swift-extensions/swiftui-charts
#https://github.com/mecid/SwiftUICharts
#https://github.com/SimformSolutionsPvtLtd/SSToastMessage
#https://github.com/SimformSolutionsPvtLtd/SSCustomTabbar
#https://github.com/apptekstudios/ASCollectionView
#https://github.com/jboullianne/SimpleCCForm
#https://github.com/jboullianne/CreditCardView
