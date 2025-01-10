//
//  TurboLocationOptions.swift
//  react-native-turbo-location
//
//  Created by rom on 09/01/2025.
//

import CoreLocation

@objc public class TurboLocationOptions: NSObject {
    @objc public var distanceFilter: CLLocationDistance = kCLDistanceFilterNone
    @objc public var pauseUpdatesAutomatically: Bool = false
    @objc public var accuracy: Int = LocationAccuracy.medium.rawValue
    
    @objc public override init() {
        super.init()
    }
    
    @objc public convenience init(
        distanceFilter: CLLocationDistance,
        pauseUpdatesAutomatically: Bool,
        accuracy: Int
    ) {
        self.init()
        self.distanceFilter = distanceFilter
        self.pauseUpdatesAutomatically = pauseUpdatesAutomatically
        self.accuracy = accuracy
    }
}

@objc public enum LocationAccuracy: Int {
    case low = 1
    case balanced = 2
    case medium = 3
    case high = 4

    public func toCLLocationAccuracy() -> CLLocationAccuracy {
        switch self {
        case .low:
            return kCLLocationAccuracyKilometer
        case .balanced:
            return kCLLocationAccuracyNearestTenMeters
        case .medium:
            return kCLLocationAccuracyBestForNavigation
        case .high:
            return kCLLocationAccuracyBest
        }
    }
}

