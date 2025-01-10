//
//  TurboLocationImplDelegate.swift
//  react-native-turbo-location
//
//  Created by rom on 09/01/2025.
//

import CoreLocation

protocol TurboLocationImplDelegate: AnyObject {
    func onPermissionChange(_ provider: TurboLocationImpl, status: CLAuthorizationStatus)
    func onLocationChange(_ provider: TurboLocationImpl, location: CLLocation)
}
