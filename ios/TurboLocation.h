
#ifdef RCT_NEW_ARCH_ENABLED

    #import "RNTurboLocationSpec.h"
    @interface TurboLocation : NSObject <NativeTurboLocationSpec>
#else
    #import <React/RCTBridgeModule.h>
    @interface TurboLocation : NSObject <RCTBridgeModule>

#endif
@end

