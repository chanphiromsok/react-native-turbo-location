//
//  TurboLocationImpl.swift
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
        continuousLocationProvider.desiredAccuracy = kCLLocationAccuracyBest
        continuousLocationProvider.distanceFilter = kCLDistanceFilterNone
    }
    
    @objc public func startWatching(_ options: NSDictionary){
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        let useLiveUpdate = options["useLiveUpdate"] as? Bool ?? false
        let desiredAccuracy = TurboLocationUtils.toDesiredAccuracy(options["desiredAccuracy"] as? String)
        if #available(iOS 17.0, *), useLiveUpdate {
            startLocationLiveUpdates()
        } else {
            let activityType = TurboLocationUtils.toActivityType(options["activityType"] as? String)
            let distanceFilter = options["distanceFilter"] as?Double ?? 1.0
            let pauseUpdate = options["pausesLocationUpdatesAutomatically"] as? Bool ?? true
            continuousLocationProvider.distanceFilter = distanceFilter
            continuousLocationProvider.pausesLocationUpdatesAutomatically = pauseUpdate
            continuousLocationProvider.desiredAccuracy = desiredAccuracy
            continuousLocationProvider.activityType = activityType
            continuousLocationProvider.startUpdatingLocation()
        }
    }
    
    @objc public func getCurrentLocation(_ options: NSDictionary, 
                                         success: @escaping (NSDictionary) -> Void,
                                         failure: @escaping (NSDictionary) -> Void) -> Void {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        self.successCallback = success
        self.failureCallback = failure
        let activityType = TurboLocationUtils.toActivityType(options["activityType"] as? String)
        let desiredAccuracy = TurboLocationUtils.toDesiredAccuracy(options["desiredAccuracy"] as? String)
        
        continuousLocationProvider.desiredAccuracy = desiredAccuracy;
        continuousLocationProvider.activityType = activityType;
        continuousLocationProvider.requestLocation()
    }
    
    @available(iOS 17.0, *)
    private func startLocationLiveUpdates() {
        locationUpdateTask?.cancel()
        locationUpdateTask = Task {
            do {
                for try await locationUpdates in CLLocationUpdate.liveUpdates(.otherNavigation) {
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
    
    @objc public func requestPermission() -> Void {
        continuousLocationProvider.requestWhenInUseAuthorization()
    }
    
    @objc public func stopUpdatingLocation(){
        if #available(iOS 17.0, *){
            locationUpdateTask?.cancel()
            locationUpdateTask = nil
        }else{
            continuousLocationProvider.stopUpdatingLocation()
        }
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
