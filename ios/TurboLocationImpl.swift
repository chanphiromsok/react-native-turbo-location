//
//  LocationProvider.swift
//  react-native-turbo-location
//
//  Created by rom on 4/1/25.
//

import CoreLocation
import Foundation
import UIKit

@objc
public class TurboLocationImpl: NSObject {
    private let continuousLocationProvider: CLLocationManager
    private let eventManager: TurboLocationEventManager = TurboLocationEventManager()
    private var successCallback: ((NSDictionary) -> Void)?
    private var failureCallback: ((NSError) -> Void)?
    private var isOneShoot = false
    
    @objc(init)
    public override init() {
        continuousLocationProvider = CLLocationManager()
        super.init()
        continuousLocationProvider.delegate = self
    }
    
    
    @objc public func startWatching(options: TurboLocationOptions){
        
        
        
    }
    
    @objc public func getCurrentLocation(_ success: @escaping (NSDictionary) -> Void,
                                         failure: @escaping (NSError) -> Void) -> Void {
        self.successCallback = success
        self.failureCallback = failure
        continuousLocationProvider.distanceFilter = kCLDistanceFilterNone
        continuousLocationProvider.requestLocation()
    }
    
    
    @objc public func requestPermission() -> Void {
        
        //        continuousLocationProvider?.requestPermission("whenInUse")
    }
    
    @objc public func stopUpdatingLocation(){
        //        continuousLocationProvider?.removeLocationUpdates()
    }
    // Event Emitter Setup
    @objc public func setEventManager(delegate: TurboLocationEventEmitterDelegate) {
        self.eventManager.delegate = delegate
    }
    
    
}

extension TurboLocationImpl: CLLocationManagerDelegate, TurboLocationProviderDelegate {
    
    func onPermissionChange(_ provider: TurboLocationProvider, status: CLAuthorizationStatus) {
        eventManager.onPermissionChange(status: status)
    }
    
    func onLocationChange(_ provider: TurboLocationProvider, location: CLLocation) {
        eventManager.sendLocationChange(location: location);
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else { return }
        let locationDict: NSDictionary = [
            "coords": [
                "latitude": location.coordinate.latitude,
                "longitude": location.coordinate.longitude,
                "altitude": location.altitude,
                "accuracy": location.horizontalAccuracy,
                "altitudeAccuracy": location.verticalAccuracy,
                "heading": location.course,
                "speed": location.speed,
                "mocked": location.isSimulated()
            ],
            "timestamp": location.timestamp.timeIntervalSince1970 * 1000 // ms
        ]
        successCallback?(locationDict)
        
        if(isOneShoot){
            continuousLocationProvider.stopUpdatingLocation()
            successCallback=nil
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        failureCallback?(error as NSError)
    }
}
