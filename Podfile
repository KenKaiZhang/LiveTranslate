use_frameworks!

platform :ios, '17.0'

project 'LiveTranslate.xcodeproj'

pod 'GoogleMLKit/Translate', '4.0.0'

target 'LiveTranslate' do
end

# Disable signing for pods
post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
         end
    end
  end
end
