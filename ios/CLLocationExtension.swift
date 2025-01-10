//
//  TurboLocationExtension.swift
//  react-native-turbo-location
//
//  Created by rom on 10/01/2025.
//

import CoreLocation

extension CLLocation {
    func isSimulated() -> Bool {
        if #available(iOS 15.0, *) {
            return self.sourceInformation?.isSimulatedBySoftware ?? false
        } else {
            return false
        }
    }
}
