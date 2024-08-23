platform :ios, '9.0'
use_frameworks!

target 'B-iSolar' do
  pod 'SDWebImage', '~>3.7.6'
  pod 'MJRefresh'
  pod 'ZBarSDK', '~> 1.3.1'
  pod 'Charts'

  pod 'GTSDK', '2.4.4.0-noidfa' #xxx代表当前最新版本号
  pod 'BaiduMapKit', '6.0.0' # 默认集成全量包
  pod 'BMKLocationKit'
  
#  pod 'SDWebImage', '>= 5.0.0'
#  pod 'YYImage'


end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'

    end
  end
end


