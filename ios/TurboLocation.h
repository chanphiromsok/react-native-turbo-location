#import <React/RCTEventEmitter.h>

#ifdef RCT_NEW_ARCH_ENABLED

#import "RNTurboLocationSpec.h"
@interface TurboLocation : NSObject <NativeTurboLocationSpec>
#else
#import <React/RCTBridgeModule.h>
@interface TurboLocation : RCTEventEmitter <RCTBridgeModule>

#endif
@end
