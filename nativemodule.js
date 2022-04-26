import { NativeModules, NativeEventEmitter, Platform } from "react-native";
const isIOS = Platform.OS === 'ios';
const WalletConnect = NativeModules.ReactNativeWalletConnect;

const ReactNativeWalletConnect = {
  isCardNumberValid: (number) => {
    return WalletConnect.isCardNumberValid(String(number));
  },
};

export default ReactNativeWalletConnect;
