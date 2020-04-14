# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

use_frameworks!
inhibit_all_warnings!

def material_components
  pod 'MaterialComponents/TextFields'
  pod 'MaterialComponents/Buttons'
  pod 'MaterialComponents/ActivityIndicator'
  pod 'MaterialComponents/ShadowLayer'
  pod 'MaterialComponents/ShadowElevations'
  pod 'MaterialComponents/Snackbar'
  pod 'MaterialComponents/Dialogs'
end

target 'WoopEvents' do
  # Pods for WoopEvents
  
  material_components

  pod 'R.swift'
  pod 'Nuke'

  target 'WoopEventsTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'WoopEventsUITests' do
    # Pods for testing
  end

end
