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
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var trafficSwitch: UISwitch!
    
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
        
        // Apply map position and appearance settings for app based on last use
        updateMapType(index: mapIndex)
        mapSegmentedControl.selectedSegmentIndex = mapIndex
        trafficSwitch.isOn = trafficSetting
        locationSwitch.isOn = locationDisplaySetting
        map.setRegion(region, animated: true)
        map.showsTraffic = trafficSetting
        map.showsUserLocation = locationDisplaySetting
        
    }
    
    // method used by the segmented controller to change the map type accordingly
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
    
    // update the map type based on the segmented controller selection and save this state in UserDefaults to recall next time the app is opened
    @IBAction func updateSegmentIndex(_ sender: UISegmentedControl) {
        updateMapType(index: sender.selectedSegmentIndex)
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey:"mapType")
    }
    
    // toggle location display based on switch action and then save this state in UserDefaults to recall next time the app is opened
    @IBAction func toggleShowsLocation(_ sender: UISwitch) {
        let currentState = UserDefaults.standard.bool(forKey: "defaultLocationDisplaySetting")
        debugPrint(currentState)
        UserDefaults.standard.set(!currentState, forKey:"defaultLocationDisplaySetting")
    }
    
    // toggle traffic overlay based on switch action and then save this state in UserDefaults to recall next time the app is opened
    @IBAction func toggleShowsTraffic(_ sender: UISwitch) {
        let currentState = UserDefaults.standard.bool(forKey: "defaultTrafficSetting")
        debugPrint(currentState)
        UserDefaults.standard.set(!currentState, forKey:"defaultTrafficSetting")
    }
    
}

