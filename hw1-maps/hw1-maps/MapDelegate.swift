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

class MapDelegate: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    var breadCrumbs: [MKPointAnnotation] = []
    
    func startLocationLogging () {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // update the saved map position settings every time the user changes them
    func mapView(_ map: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        UserDefaults.standard.set(map.region.center.latitude, forKey:"defaultLatitude")
        UserDefaults.standard.set(map.region.center.longitude, forKey:"defaultLongitude")
        UserDefaults.standard.set(map.region.span.latitudeDelta, forKey:"defaultLatDelta")
        UserDefaults.standard.set(map.region.span.longitudeDelta, forKey:"defaultLongDelta")

    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocationPin = MKPointAnnotation()
        let newUserLocation: CLLocation = locations[0]
        
        let newUserLatitude = newUserLocation.coordinate.latitude
        let newUserLongitude = newUserLocation.coordinate.longitude
        let newUserCenter = CLLocationCoordinate2D(latitude: newUserLatitude, longitude: newUserLongitude)
        
        newLocationPin.coordinate = newUserCenter
        
        map.addAnnotation(newLocationPin)
        breadCrumbs.append(newLocationPin)
        
        UserDefaults.standard.set(breadCrumbs, forKey:"savedBreadCrumbs")
    }
}
  
