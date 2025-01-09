#import "TurboLocation.h"
#import <CoreLocation/CoreLocation.h>
#if __has_include("react_native_turbo_location-Swift.h")
#import "react_native_turbo_location-Swift.h"
#else
#import "react_native_turbo_location/react_native_turbo_location-Swift.h"
#endif

//static TurboLocationImpl *_director = [TurboLocationImpl new];
@interface TurboLocation () <TurboLocationEventEmitterDelegate>
@end
@implementation TurboLocation {
    TurboLocationImpl *turboLocation;
}
RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (instancetype)init {
  self = [super init];
  if(self) {
    // Option 2.B - Instantiate the Calculator and set the delegate
      turboLocation = [TurboLocationImpl new];
      [turboLocation setEventManagerWithDelegate:self];
  }
  return self;
}

#pragma mark - Monitoring
-(void)startObserving {
    self.isJsListening = YES;
}

-(void)stopObserving {
    self.isJsListening = NO;
}

- (NSArray<NSString *> *)supportedEvents {
    return [EventManager supportedEvents];
}
// Options 2.D - Implement the Specs
RCT_EXPORT_METHOD(getCurrentLocation:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->turboLocation getCurrentLocation];
    });
}

RCT_EXPORT_METHOD(startWatching:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    LocationOptions *options = [[LocationOptions alloc] init];
    options.distanceFilter = 10.0;
    options.pauseUpdatesAutomatically = YES;
    options.accuracy = LocationAccuracyMedium;
    NSLog(@"startWatching");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->turboLocation startWatchingWithOption:options];
    });
}

- (void)sendEventWithName:(NSString * _Nonnull)name params:(NSDictionary *)params {
    [self sendEventWithName:name body:params];
}

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeTurboLocationSpecJSI>(params);
}
#endif

@end
