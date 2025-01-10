//
//  LocationProvider.swift
//  react-native-turbo-location
//
//  Created by rom on 09/01/2025.
//

import CoreLocation

class TurboLocationProvider: NSObject {
    private let locationManager: CLLocationManager
    weak var delegate: TurboLocationProviderDelegate?
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }
    
    deinit {
        removeLocationUpdates()
        locationManager.delegate = nil;
    }
    
    func requestPermission(_ level: String) -> Void {
        print("TurboProvider requestPermission",level)
        if level == "whenInUse" {
            locationManager.requestWhenInUseAuthorization()
        } else if level == "always" {
            locationManager.requestAlwaysAuthorization()
            
        }
    }
    
    func getCurrentLocation( _ options: TurboLocationOptions){
        locationManager.desiredAccuracy = CLLocationAccuracy(options.accuracy)
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestLocation()
    }
    
    func requestLocationUpdates( _ options: TurboLocationOptions) -> Void {
        locationManager.desiredAccuracy = CLLocationAccuracy(options.accuracy)
        locationManager.distanceFilter = options.distanceFilter
        locationManager.activityType = .otherNavigation
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.pausesLocationUpdatesAutomatically = options.pauseUpdatesAutomatically
        
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = false
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func removeLocationUpdates() -> Void {
        locationManager.stopUpdatingLocation()
    }
    
    
    
    
    @objc private func timerFired(timer: Timer) -> Void {
#if DEBUG
        NSLog("RNLocation: request timed out")
#endif
        
        //    delegate?.onLocationError(self, err: LocationError.TIMEOUT, message: nil)
        locationManager.stopUpdatingLocation()
    }
    
    private func isPermissionGranted() -> Bool{
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            @unknown default:
                return false
            }
        }
        return false
    }
}

extension TurboLocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            return
        }
        
        delegate?.onPermissionChange(self, status: status)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else { return }
        print("Locations updated: \(locations)")
        delegate?.onLocationChange(self, location: location)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //    var err = LocationError.POSITION_UNAVAILABLE
        var message: String? = nil
        
        if let clErr = error as? CLError {
            switch clErr.code {
            case CLError.denied:
                if !CLLocationManager.locationServicesEnabled() {
                    message = "Location service is turned off"
                } else {
                    //            err = LocationError.PERMISSION_DENIED
                }
            case CLError.network:
                message = "Unable to retrieve location due to a network failure"
            default:
                break
            }
        } else {
            NSLog("RNLocation: \(error.localizedDescription)")
        }
        
        
    }
}

