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
    
    
    @objc public func startWatching(_ success: @escaping (NSDictionary) -> Void){
        
        if #available(iOS 17.0, *) {
            startLocationUpdates(success)
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    @available(iOS 17.0, *)
    func startLocationUpdates(_ success: @escaping (NSDictionary) -> Void) {
        // Take location permissions before
        Task {
            do {
                let updates = CLLocationUpdate.liveUpdates()
                for try await update in updates {
                    let locationDict: NSDictionary = [
                        "coords": [
                            "latitude": update.location?.coordinate.latitude as Any,
                            "longitude": update.location?.coordinate.longitude,
                            "altitude": update.location?.altitude,
                            "accuracy": update.location?.horizontalAccuracy,
                            "altitudeAccuracy": update.location?.verticalAccuracy,
                            "heading": update.location?.course,
                            "speed": update.location?.speed,
                            "mocked": update.location?.isSimulated()
                        ],
                        "timestamp": (update.location?.timestamp.timeIntervalSince1970)! * 1000 // ms
                    ]
//                    TODO use even emitter
                    print ("Current Location is \(String(describing: update.location))")

                    
                    // To stop updates break out of the for loop
                    if update.isStationary {
                        break
                    }
                }
            } catch {
                debugPrint("Some Error Occured")
            }
        }
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

extension TurboLocationImpl: CLLocationManagerDelegate, TurboLocationImplDelegate {
    
    func onPermissionChange(_ provider: TurboLocationImpl, status: CLAuthorizationStatus) {
        eventManager.onPermissionChange(status: status)
    }
    
//    func onLocationChange(_ provider: TurboLocationImpl, location: CLLocation) {
//        eventManager.sendLocationChange(location: location);
//    }
    
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
