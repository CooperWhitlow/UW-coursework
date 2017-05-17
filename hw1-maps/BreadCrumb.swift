//
//  BreadCrumbs.swift
//  hw1-maps
//
//  Created by Cooper Whitlow on 5/11/17.
//  Copyright © 2017 Cooper Whitlow. All rights reserved.
//

import Foundation
import MapKit

class BreadCrumb: NSObject, MKAnnotation, NSCoding {
    
    static let titleKey = "Title"
    static let subtitleKey = "Subtitle"
    static let latitudeKey = "Latitude"
    static let longitudeKey = "Longitude"
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(latitude: Double, longitude: Double, title: String?, subtitle: String?) {
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.title = title
        self.subtitle = subtitle
    }
    
    init(latitude: Double, longitude: Double) {
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //self.title = title
        self.subtitle = Date().description
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey:BreadCrumb.titleKey)
        aCoder.encode(subtitle, forKey:BreadCrumb.subtitleKey)
        aCoder.encode(coordinate.latitude, forKey:BreadCrumb.latitudeKey)
        aCoder.encode(coordinate.longitude, forKey:BreadCrumb.longitudeKey)
    }
    
    required init?(coder: NSCoder) {
        if let decodedTitle = coder.decodeObject(forKey: BreadCrumb.titleKey) as? String {
            title = decodedTitle
        }
        if let decodedSubtitle = coder.decodeObject(forKey: BreadCrumb.subtitleKey) as? String {
            subtitle = decodedSubtitle
        }
        let latitude = coder.decodeDouble(forKey: BreadCrumb.latitudeKey)
        let longitude = coder.decodeDouble(forKey: BreadCrumb.longitudeKey)
        coordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
    }
}
