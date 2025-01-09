//
//  LocationProvider.swift
//  react-native-turbo-location
//
//  Created by rom on 4/1/25.
//

import Foundation


@objcMembers
public class LocationProvider: NSObject {
    static public func getCurrentLocation(){
        print("getCurrentLocation")
    }
    public static func multiply(a: Double, b: Double) -> Double {
        return a * b
    }
}
