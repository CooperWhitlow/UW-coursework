//
//  MapPreferences.swift
//  hw1-maps
//
//  Created by Cooper Whitlow on 4/21/17.
//  Copyright © 2017 Cooper Whitlow. All rights reserved.
//

import UIKit
import CoreLocation

class MapPreferences {
    static func initializeDefaults() {

        // Default map settings. These update with stored values as the user interacts with the map.
        let defaultsDictionary: [String: Any] = [
            "mapType": 0 as AnyObject,
            "defaultTrafficSetting": false as AnyObject,
            "defaultLocationSetting": false as AnyObject,
            "defaultTrackingSetting": false as AnyObject,
            "defaultLatitude": 47.670435 as AnyObject,
            "defaultLongitude": -122.383108 as AnyObject,
            "defaultLatDelta": 10.0 as Double,
            "defaultLongDelta": 10.0 as Double
        ]
        
        UserDefaults.standard.register(defaults: defaultsDictionary)
        NSUbiquitousKeyValueStore.default()
        
    }
}
