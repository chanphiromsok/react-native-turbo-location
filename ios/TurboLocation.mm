#import "TurboLocation.h"

#if __has_include("react_native_turbo_location-Swift.h")
#import "react_native_turbo_location-Swift.h"
#else
#import "react_native_turbo_location/react_native_turbo_location-Swift.h"
#endif

@implementation TurboLocation
RCT_EXPORT_MODULE()


- (NSNumber *)multiply:(double)a b:(double)b {
    NSNumber *result = @(a * b);
    return result;
}
RCT_EXPORT_METHOD(multiply:(double)a
                  b:(double)b
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    double result =  [LocationProvider multiplyWithA:a b:b]; // 👈
    resolve([NSNumber numberWithDouble:result]); // 👈
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeTurboLocationSpecJSI>(params);
}

@end
