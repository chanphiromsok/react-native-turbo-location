//
//  EventManager.swift
//  react-native-turbo-location
//
//  Created by rom on 09/01/2025.
//

import Foundation
import CoreLocation

@objc
public class EventManager:NSObject {
    @objc public weak var delegate: TurboLocationEventEmitterDelegate? = nil
    
    func sendLocationChange(location: CLLocation) {
        guard let delegate = delegate else {
            return
        }
        if (!delegate.isJsListening) {
            return
        }
        print(Event.onLocationChange.rawValue)
        let params = [
            "latitude" : location.coordinate.latitude,
            "longitude" : location.coordinate.longitude,
            "heading" : location.course,
            "speed" : location.speed,
            "accuracy": location.speedAccuracy,
            "timestamp": location.timestamp,
            "altitude": location.altitude
            
        ] as [String : Any]
        delegate.sendEvent(name: Event.onLocationChange.rawValue, params: params as NSDictionary)
    }
    
    func onPermissionChange(status: CLAuthorizationStatus) {
        guard let delegate = delegate else {
            return
        }
        if (!delegate.isJsListening) {
            return
        }
        print(Event.didAuthorizedChange.rawValue)
        let params = Dictionary(dictionaryLiteral: ("status", status))
        delegate.sendEvent(name: Event.didAuthorizedChange.rawValue, params: params as NSDictionary)
    }
}


@objc public protocol TurboLocationEventEmitterDelegate {
    var isJsListening: Bool { get set }
    func sendEvent(name: String, params: NSDictionary)
}

extension EventManager {
    
    enum Event: String, CaseIterable {
        case onLocationChange
        case didAuthorizedChange
    }
    
    @objc public static var supportedEvents: [String] {
        return Event.allCases.map(\.rawValue);
    }
}
