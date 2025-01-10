//
//  TurboLocationEventManager.swift
//  react-native-turbo-location
//
//  Created by rom on 09/01/2025.
//

import CoreLocation

@objc
public class TurboLocationEventManager:NSObject {
    @objc public weak var delegate: TurboLocationEventEmitterDelegate? = nil
    
    func onLocationChange(location: CLLocation) {
        guard let delegate = delegate else {
            return
        }
        if (!delegate.isJsListening) {
            return
        }
        let params = locationToDict(location)
        delegate.sendEvent(name: Event.onLocationChange.rawValue, params: params as NSDictionary)
    }
    
    func onPermissionChange(status: CLAuthorizationStatus) {
        guard let delegate = delegate else {
            return
        }
        if (!delegate.isJsListening) {
            return
        }
        let params = Dictionary(dictionaryLiteral: ("status", status))
        delegate.sendEvent(name: Event.didAuthorizedChange.rawValue, params: params as NSDictionary)
    }
    
    private func locationToDict(_ location: CLLocation) -> [String: Any] {
        return [
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
    }
}


@objc public protocol TurboLocationEventEmitterDelegate {
    var isJsListening: Bool { get set }
    func sendEvent(name: String, params: NSDictionary)
}

extension TurboLocationEventManager {
    
    enum Event: String, CaseIterable {
        case onLocationChange
        case didAuthorizedChange
    }
    
    @objc public static var supportedEvents: [String] {
        return Event.allCases.map(\.rawValue);
    }
}
