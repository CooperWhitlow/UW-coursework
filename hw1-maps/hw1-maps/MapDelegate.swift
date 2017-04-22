//
//  MapDelegate.swift
//  hw1-maps
//
//  Created by Cooper Whitlow on 4/22/17.
//  Copyright © 2017 Cooper Whitlow. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapDelegate: NSObject, MKMapViewDelegate {
    
    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    
    func mapView(_ map: MKMapView) {
        
    }
   
    func mapView(_ map: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        debugPrint(map.region)
        
        UserDefaults.standard.set(map.region.center.latitude, forKey:"defaultLatitude")
        UserDefaults.standard.set(map.region.center.longitude, forKey:"defaultLongitude")
        UserDefaults.standard.set(map.region.span.latitudeDelta, forKey:"defaultLatDelta")
        UserDefaults.standard.set(map.region.span.longitudeDelta, forKey:"defaultLongDelta")
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            
        }
    }
    
}
  
