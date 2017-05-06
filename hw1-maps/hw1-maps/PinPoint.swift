//
//  PinPoint.swift
//  hw1-maps
//
//  Created by Cooper Whitlow on 4/24/17.
//  Copyright © 2017 Cooper Whitlow. All rights reserved.
//

import UIKit
import MapKit

class PinPoint: NSObject, MKAnnotation {
   
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(latitude: Double, longitude: Double, title: String) {
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.title = title
    }
    
    
}
