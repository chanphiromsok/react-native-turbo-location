//
//  LocationProvider.swift
//  react-native-turbo-location
//
//  Created by rom on 4/1/25.
//

import Foundation


@objc
public class TurboLocationImpl: NSObject {
    private let eventManager: EventManager = EventManager()
    // Event Emitter Setup
    @objc public func setEventManager(delegate: TurboLocationEventEmitterDelegate) {
        self.eventManager.delegate = delegate
    }
    //
    @objc public func getCurrentLocation(){
        print("getCurrentLocation")
        eventManager.sendLocationChange(orientationValue: 10);
    }
}
