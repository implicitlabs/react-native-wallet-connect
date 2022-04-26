
#import <Foundation/Foundation.h>
#import "React/RCTViewManager.h"
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(ReactNativeWalletConnect, RCTViewManager)

RCT_EXTERN_METHOD(isCardNumberValid:(NSString *)number resolve: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

@end
