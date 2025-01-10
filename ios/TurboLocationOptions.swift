//
//  TurboLocationOptions.swift
//  react-native-turbo-location
//
//  Created by rom on 09/01/2025.
//

import CoreLocation

@objc public class TurboLocationOptions: NSObject {
    @objc public var enableHighAccuracy: Bool = false
    @objc public var distanceFilter: CLLocationDistance = kCLDistanceFilterNone
    @objc public var interval: Int = 1000
}
