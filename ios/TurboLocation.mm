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
    TurboLocationOptions *options;
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
        turboLocation = [[TurboLocationImpl alloc] init];
        options = [[TurboLocationOptions alloc] init];
        [turboLocation setEventManagerWithDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [self->turboLocation stopUpdatingLocation];
    self->turboLocation = nil;
    self->options = nil;
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
// Options 2.D - Implement the Specs
typedef void(^TurboCallback)(NSDictionary *location);

RCT_EXPORT_METHOD(getCurrentLocation:(RCTResponseSenderBlock)successCallback
                         errorCallback:(RCTResponseSenderBlock)errorCallback) {
    
    TurboCallback success = ^(NSDictionary *location) {
        successCallback(@[location]);
    };
    
    TurboCallback failure= ^(NSDictionary *error) {
        errorCallback(@[error]);
    };
    
    [self->turboLocation getCurrentLocation:success failure:failure];
}
RCT_EXPORT_METHOD(startWatching:(RCTResponseSenderBlock)successCallback) {
    TurboCallback callback = ^(NSDictionary *location) {
            successCallback(@[location]);
    };
    [turboLocation startWatching:callback];
}

RCT_EXPORT_METHOD(stopUpdatingLocation) {
    [turboLocation stopUpdatingLocation];
};


RCT_EXPORT_METHOD(requestPermission:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->turboLocation requestPermission];
    });
    resolve(@"Ok");
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
