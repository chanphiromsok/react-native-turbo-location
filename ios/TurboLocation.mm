#import "TurboLocation.h"
#import <CoreLocation/CoreLocation.h>
#if __has_include("react_native_turbo_location-Swift.h")
#import "react_native_turbo_location-Swift.h"
#else
#import "react_native_turbo_location/react_native_turbo_location-Swift.h"
#endif


@interface TurboLocation () <TurboLocationEventEmitterDelegate>
@end

@implementation TurboLocation {
    TurboLocationImpl *turboLocation;
}
// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeTurboLocationSpecJSI>(params);
}
#endif

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        // Option 2.B - Instantiate the Calculator and set the delegate
        turboLocation = [[TurboLocationImpl alloc] init];
        [turboLocation setEventManagerWithDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [self->turboLocation stopUpdatingLocation];
    self->turboLocation = nil;
}

#pragma mark - Monitoring
-(void)startObserving {
    self.isJsListening = YES;
}

-(void)stopObserving {
    self.isJsListening = NO;
}

- (NSArray<NSString *> *)supportedEvents {
    return [TurboLocationEventManager supportedEvents];
}
// https://github.com/reactwg/react-native-new-architecture/blob/main/docs/enable-libraries-ios.md callback:(RCTResponseSenderBlock)callback
typedef void(^TurboCallback)(NSDictionary *location);
RCT_EXPORT_METHOD(getCurrentLocation:(NSDictionary *)options
                  successCallback:(RCTResponseSenderBlock)successCallback
                  errorCallback:(RCTResponseSenderBlock)errorCallback) {
    
    TurboCallback success = ^(NSDictionary *location) {
        successCallback(@[location]);
    };
    
    TurboCallback failure= ^(NSDictionary *error) {
        errorCallback(@[error]);
    };
#ifdef DEBUG
    NSLog(@"getCurrentLocation SHOW_ONLY_DEBUG %@",options);
#endif
    
    [self->turboLocation getCurrentLocation:options success: success failure:failure];
}
RCT_EXPORT_METHOD(startWatching:(NSDictionary *) options) {
#ifdef DEBUG
    NSLog(@"startWatching SHOW_ONLY_DEBUG %@",options);
#endif
    [self->turboLocation startWatching: options];
}

RCT_EXPORT_METHOD(stopWatching) {
    [self->turboLocation stopUpdatingLocation];
};

RCT_EXPORT_METHOD(requestPermission:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->turboLocation requestPermission];
    });
    
}


- (void)sendEventWithName:(NSString * _Nonnull)name params:(NSDictionary *)params {
    [self sendEventWithName:name body:params];
}

@end
