//
//  LocationProvider.swift
//  react-native-turbo-location
//
//  Created by rom on 09/01/2025.
//

import CoreLocation

class TurboLocationProvider: NSObject {
    private let locationManager: CLLocationManager
    private var locationOptions: LocationOptions? = nil
    weak var delegate: TurboLocationProviderDelegate?
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }
    
    deinit {
        removeLocationUpdates()
        locationManager.delegate = nil;
        locationOptions=nil
    }
    
    func requestLocationUpdates(option: LocationOptions) -> Void {
        locationOptions = option
        locationManager.desiredAccuracy = CLLocationAccuracy(locationOptions!.accuracy)
        locationManager.distanceFilter = locationOptions!.distanceFilter
        locationManager.activityType = .automotiveNavigation
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.pausesLocationUpdatesAutomatically = locationOptions!.pauseUpdatesAutomatically

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
}

extension TurboLocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // When CLLocationManager instance is created, it'll trigger this method.
        // Status can be undetermined in that case.
        if status == .notDetermined {
            return
        }
        
        delegate?.onPermissionChange(self, status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else { return }
        
#if DEBUG
        NSLog("RNLocation: \(location.coordinate.latitude), \(location.coordinate.longitude)")
#endif
        
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
