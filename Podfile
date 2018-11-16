source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

def common_pods
  pod 'RealmSwift'
  pod 'AMWaveTransition', '~> 0.5'
  pod 'AHKActionSheet', '~> 0.5'
  pod 'pop', '~> 1.0'
  pod 'AMPopTip'
  pod 'UICountingLabel', '~> 1.2'
  pod 'CVCalendar'
  pod 'BAFluidView', '~> 0.2.3'
  pod 'BubbleTransition', '~> 2.0.0'
  pod 'TinyConstraints'
end

target 'Gulps' do
  common_pods
  pod 'Reveal-SDK', :configurations => ['Debug']
end

target 'GulpsTests' do
  common_pods
  pod 'Nimble'
  pod 'Quick'
  pod 'Nimble-Snapshots'
  pod 'FBSnapshotTestCase'
end
