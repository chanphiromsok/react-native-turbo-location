//
//  LocationProvider.swift
//  react-native-turbo-location
//
//  Created by rom on 4/1/25.
//

import Foundation
import CoreLocation


@objc
public class TurboLocationImpl: NSObject {
    private var continuousLocationProvider: TurboLocationProvider? = nil

    @objc public func startWatching(option: LocationOptions?){
            var locationOption = option
            if continuousLocationProvider == nil {
                continuousLocationProvider = TurboLocationProvider()
                continuousLocationProvider!.delegate = self
            }
            if locationOption == nil {
                locationOption = LocationOptions()
            }
            DispatchQueue.main.async { [self] in
                continuousLocationProvider?.requestLocationUpdates(option: locationOption!)
            }
        }
        
        func stopUpdatingLocation(){
            DispatchQueue.main.async { [self] in
                continuousLocationProvider?.removeLocationUpdates()
            }
        }
    private let eventManager: EventManager = EventManager()
    // Event Emitter Setup
    @objc public func setEventManager(delegate: TurboLocationEventEmitterDelegate) {
        self.eventManager.delegate = delegate
    }
    //
    @objc public func getCurrentLocation(){
        print("getCurrentLocation")
        eventManager.sendLocationChange(orientationValue: 10);
    }
}

extension TurboLocationImpl: TurboLocationProviderDelegate {
    
    func onPermissionChange(_ provider: TurboLocationProvider, status: CLAuthorizationStatus) {
        print("onPermissionChange \(status)")
    }
    
    func onLocationChange(_ provider: TurboLocationProvider, location: CLLocation) {
//        sendEvent("onLocation",[
//            "latitude" : location.coordinate.latitude,
//            "longitude" : location.coordinate.longitude,
//            "heading" : location.course,
//            "speed" : location.speed
//        ])
        eventManager.sendLocationChange(orientationValue: location.coordinate.latitude);
    }
    
}
