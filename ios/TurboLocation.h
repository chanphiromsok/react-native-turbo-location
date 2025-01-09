#import <React/RCTEventEmitter.h>

#ifdef RCT_NEW_ARCH_ENABLED

#import "RNTurboLocationSpec.h"

NS_ASSUME_NONNULL_BEGIN

@interface TurboLocation : RCTEventEmitter <NativeTurboLocationSpec>

NS_ASSUME_NONNULL_END

#else
#import <React/RCTBridgeModule.h>
@interface TurboLocation : RCTEventEmitter <RCTBridgeModule>
#endif
@property (nonatomic, assign) BOOL isJsListening;
@end
