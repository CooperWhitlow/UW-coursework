//
//  ViewController.swift
//  hw1-maps
//
//  Created by Cooper Whitlow on 4/21/17.
//  Copyright © 2017 Cooper Whitlow. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var mapSegmentedControl: UISegmentedControl!
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Pull settings saved in UserDefualts to restore appearance from users' last use
        let mapIndex = UserDefaults.standard.integer(forKey: "mapType")
        let latitude = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLatitude"))
        let longitude = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLongitude"))
        let latDelta = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLatDelta"))
        let longDelta = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLongDelta"))
        let trafficSetting = UserDefaults.standard.bool(forKey: "defaultTrafficSetting")
        let locationDisplaySetting = UserDefaults.standard.bool(forKey: "defaultLocationDisplaySetting")
        
        // Define map position for this use
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        
        // Apply map position and appearance settings
        updateMapType(index: mapIndex)
        mapSegmentedControl.selectedSegmentIndex = mapIndex
        map.setRegion(region, animated: true)
        map.showsTraffic = trafficSetting
        map.showsUserLocation = locationDisplaySetting
        
    }
    
    //method used to pass the segmented controller selection ans change the map type accordings
    func updateMapType(index: Int) {
        switch index {
        case 0:
            map.mapType = .standard
        case 1:
            map.mapType = .hybrid
        case 2:
            map.mapType = .satellite
        default:
            abort()
        }
    }
    
    //segmented controlelr action to update current map type and save selection for later use
    @IBAction func updateSegmentIndex(_ sender: UISegmentedControl) {
        updateMapType(index: sender.selectedSegmentIndex)
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey:"mapType")
    }
}

