project 'Project/PubNub'
workspace 'PubNub'
use_frameworks!

target 'PubNubPlayground' do
	pod 'PubNub'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
    end
  end
end
