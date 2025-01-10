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
    
    @objc public func startWatching(option: TurboLocationOptions?){
        var locationOption = option
        if continuousLocationProvider == nil {
            continuousLocationProvider = TurboLocationProvider()
            continuousLocationProvider!.delegate = self
        }
        if locationOption == nil {
            locationOption = TurboLocationOptions()
        }
        continuousLocationProvider?.requestLocationUpdates(option: locationOption!)
    }
    
    @objc public func getCurrentLocation(option: TurboLocationOptions?) -> Void {
        var locationOption = option
        if continuousLocationProvider == nil {
            continuousLocationProvider = TurboLocationProvider()
            continuousLocationProvider?.delegate = self
        }
        if locationOption == nil {
            locationOption = TurboLocationOptions()
        }
        continuousLocationProvider?.getCurrentLocation(option: locationOption!)
    }
    
    @objc public func requestPermission() -> Void {
        if continuousLocationProvider == nil {
            continuousLocationProvider = TurboLocationProvider()
            continuousLocationProvider!.delegate = self
        }
        continuousLocationProvider?.requestPermission("whenInUse")
    }
    
    @objc public func stopUpdatingLocation(){
        DispatchQueue.main.async { [self] in
            continuousLocationProvider?.removeLocationUpdates()
        }
    }
    private let eventManager: TurboLocationEventManager = TurboLocationEventManager()
    // Event Emitter Setup
    @objc public func setEventManager(delegate: TurboLocationEventEmitterDelegate) {
        self.eventManager.delegate = delegate
    }

}

extension TurboLocationImpl: TurboLocationProviderDelegate {
    
    func onPermissionChange(_ provider: TurboLocationProvider, status: CLAuthorizationStatus) {
        eventManager.onPermissionChange(status: status)
    }
    
    func onLocationChange(_ provider: TurboLocationProvider, location: CLLocation) {
        print("onLocationChange \(location)")
        eventManager.sendLocationChange(location: location);
    }
    
}

extension CLLocation {
    func isSimulated() -> Bool {
        if #available(iOS 15.0, *) {
            return self.sourceInformation?.isSimulatedBySoftware ?? false
        } else {
            return false
        }
    }
}
