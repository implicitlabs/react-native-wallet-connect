require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))
version = package['version']

Pod::Spec.new do |s|
    s.name         = 'ReactNativeWalletConnect'
    s.version      = version
    s.summary      = "A native ReactNativeWalletConnect react native component."

    s.description  = "A native ReactNativeWalletConnect react native component."

    s.homepage     = "https://github.com/implicitlabs/react-native-wallet-connect"
    s.license      = "COMMERCIAL"
    s.author       = { "Hayk Zohrabyan" => "haykz@implicitlabs.com" }
    s.source_files = 'ios/*.{h,m,swift,tflite,txt}'
    s.source       = { :git => "https://github.com/implicitlabs/react-native-wallet-connect.git", :tag => "#{s.version}" }

    s.requires_arc = true
    s.platform     = :ios, '11.0'


    # Pods for ImageClassification

    s.preserve_paths = 'LICENSE', 'README.md', 'package.json', 'index.js'

    s.dependency 'React-Core'
    s.dependency "WalletConnectSwift"

    s.swift_version = "5.4"
    s.swift_versions = ['4.0', '4.2', '5.0', '5.1', '5.2', '5.3', '5.4']
end
