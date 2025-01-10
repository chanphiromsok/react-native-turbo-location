//
//  LocationProvider.swift
//  react-native-turbo-location
//
//  Created by rom on 4/1/25.
//

import CoreLocation

@objc
public class TurboLocationImpl: NSObject {
    private let continuousLocationProvider: CLLocationManager
    private let eventManager: TurboLocationEventManager = TurboLocationEventManager()
    private var successCallback: ((NSDictionary) -> Void)?
    private var failureCallback: ((NSDictionary) -> Void)?
    private var isOneShoot = false
    private var locationUpdateTask: Task<Void, Never>?

    @objc(init)
    public override init() {
        continuousLocationProvider = CLLocationManager()
        super.init()
        continuousLocationProvider.delegate = self
    }
    
    
    @objc public func startWatching(_ success: @escaping (NSDictionary) -> Void){
        if #available(iOS 17.0, *) {
            startLocationLiveUpdates()
        } else {
            continuousLocationProvider.startUpdatingLocation()
        }
    }
    
    
    @available(iOS 17.0, *)
    func startLocationLiveUpdates() {
        // Take location permissions before
        locationUpdateTask?.cancel()
        locationUpdateTask = Task {
            do {
                for try await locationUpdates in CLLocationUpdate.liveUpdates() {
                    guard let location = locationUpdates.location else {
                        return
                    }
                    
                    eventManager.onLocationChange(location: location)
                    if locationUpdates.isStationary {
                        break
                    }
                }
            } catch {
                debugPrint("Some Error Occured")
            }
        }
    }
    
    @objc public func getCurrentLocation(_ success: @escaping (NSDictionary) -> Void,
                                         failure: @escaping (NSDictionary) -> Void) -> Void {
        self.successCallback = success
        self.failureCallback = failure
        continuousLocationProvider.distanceFilter = kCLDistanceFilterNone
        continuousLocationProvider.pausesLocationUpdatesAutomatically = false
        continuousLocationProvider.activityType = .otherNavigation
        continuousLocationProvider.desiredAccuracy = kCLLocationAccuracyBest
        
        continuousLocationProvider.requestLocation()
    }
    
    
    @objc public func requestPermission() -> Void {
        continuousLocationProvider.requestWhenInUseAuthorization()
    }
    
    @objc public func stopUpdatingLocation(){
        locationUpdateTask?.cancel()
        locationUpdateTask = nil
        
        
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
    
    func onLocationChange(_ provider: TurboLocationImpl, location: CLLocation) {
        eventManager.onLocationChange(location: location);
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
        
        
        if(isOneShoot){
            successCallback?(locationDict)
            continuousLocationProvider.stopUpdatingLocation()
            successCallback=nil
        }else{
            eventManager.onLocationChange(location: location)
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        failureCallback?(["message" : error.localizedDescription])
    }
}
