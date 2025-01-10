//
//  TurboLocationProviderDelegate.swift
//  react-native-turbo-location
//
//  Created by rom on 09/01/2025.
//

import CoreLocation

protocol TurboLocationProviderDelegate: AnyObject {
    func onPermissionChange(_ provider: TurboLocationProvider, status: CLAuthorizationStatus)
    func onLocationChange(_ provider: TurboLocationProvider, location: CLLocation)
}
