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
    
    override func viewDidAppear(_ animated: Bool) {
        
        let mapIndex = UserDefaults.standard.integer(forKey: "mapType")
        let latitude = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLatitude"))
        let longitude = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLongitude"))
        let latDelta = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLatDelta"))
        let longDelta = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLongDelta"))
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region = MKCoordinateRegion(center: coordinates, span: span)
                
        
        map.setRegion(region, animated: true)
        updateMapType(index: mapIndex)
        mapSegmentedControl.selectedSegmentIndex = mapIndex
        
    }
    
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
    
    @IBAction func updateSegmentIndex(_ sender: UISegmentedControl) {
        updateMapType(index: sender.selectedSegmentIndex)
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey:"mapType")
    }
}

