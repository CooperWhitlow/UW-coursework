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

        //starting map settings. These update with stored values as the user changes them.
        let defaultsDictionary: [String: AnyObject] = [
            "mapType": 0 as AnyObject,
            "defaultTrafficSetting": true as AnyObject,
            "defaultLocationDisplaySetting": true as AnyObject,
            "defaultLatitude": 0 as AnyObject,
            "defaultLongitude": 0 as AnyObject,
            "defaultLatDelta": 100 as AnyObject,
            "defaultLongDelta": 100 as AnyObject
        ]
        
        UserDefaults.standard.register(defaults: defaultsDictionary)
        
    }
}
