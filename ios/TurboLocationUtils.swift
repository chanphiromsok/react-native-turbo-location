//
//  File.swift
//  react-native-turbo-location
//
//  Created by rom on 11/1/25.
//

import Foundation
import CoreLocation

class TurboLocationUtils {
    static func toActivityType(_ activityType: String?) -> CLActivityType {
        
        if activityType ==  "other"{
            return .other
        } else if activityType == "automotiveNavigation"{
            return .automotiveNavigation
        } else if activityType == "otherNavigation"{
            return .otherNavigation
        } else if activityType == "airborne"{
            return .airborne
        }else if activityType == "fitness"{
            return .fitness
        }
        return .other
    }
    
    static func toDesiredAccuracy(_ desiredAccuracy: String?) -> CLLocationAccuracy {
        
        if desiredAccuracy == "bestForNavigation" {
            return kCLLocationAccuracyBestForNavigation
        } else if desiredAccuracy == "best" {
            return kCLLocationAccuracyBest
        } else if desiredAccuracy == "nearestTenMeters" {
            return kCLLocationAccuracyNearestTenMeters
        } else if desiredAccuracy == "hundredMeters" {
            return kCLLocationAccuracyHundredMeters
        } else if desiredAccuracy == "threeKilometers" {
            return kCLLocationAccuracyThreeKilometers
        }
        
        return kCLLocationAccuracyBest
    }
}

