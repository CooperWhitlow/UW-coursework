//
//  MapPreferences.swift
//  hw1-maps
//
//  Created by Cooper Whitlow on 4/21/17.
//  Copyright © 2017 Cooper Whitlow. All rights reserved.
//

import UIKit

class MapPreferences {
    static func initializeDefaults() {
        let defaultsDictionary: [String: AnyObject] = ["mapType": 2 as AnyObject]
        UserDefaults.standard.register(defaults: defaultsDictionary)
    }
}
