//
//  EventManager.swift
//  react-native-turbo-location
//
//  Created by rom on 09/01/2025.
//

import Foundation

@objc
public class EventManager:NSObject {
    @objc public weak var delegate: TurboLocationEventEmitterDelegate? = nil
    
    func sendLocationChange(orientationValue: Double) {
        guard let delegate = delegate else {
            return
        }
        if (!delegate.isJsListening) {
            return
        }
        print(Event.onLocationChange.rawValue)
        let params = Dictionary(dictionaryLiteral: ("orientation", orientationValue))
        delegate.sendEvent(name: Event.onLocationChange.rawValue, params: params as NSDictionary)
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
