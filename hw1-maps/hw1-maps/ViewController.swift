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
    
    override func viewDidAppear(_ animated: Bool) {
        //ReferencePoint(latitude: 0, longitude: 0, title:"test at 0, 0")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        // Pull settings saved in UserDefualts to restore appearance from user's last use
        let mapIndex = UserDefaults.standard.integer(forKey: "mapType")
        let latitude = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLatitude"))
        let longitude = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLongitude"))
        let latDelta = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLatDelta"))
        let longDelta = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLongDelta"))
        let trafficSwitchSetting = UserDefaults.standard.bool(forKey: "defaultTrafficSetting")
        let locationDisplaySwitchSetting = UserDefaults.standard.bool(forKey: "defaultLocationDisplaySetting")
        
        // Define map position for this use
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        
        // Apply map position and appearance settings for app based on last use
        updateMapType(index: mapIndex)
        mapSegmentedControl.selectedSegmentIndex = mapIndex
        trafficSwitch.isOn = trafficSwitchSetting
        locationSwitch.isOn = locationDisplaySwitchSetting
        map.setRegion(region, animated: true)
        map.showsTraffic = trafficSwitchSetting
        map.showsUserLocation = locationDisplaySwitchSetting
    }
    
    // method used by the segmented controller to change the map type
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
        debugPrint("Changing location display from \(map.showsUserLocation)...")
        var currentState = UserDefaults.standard.bool(forKey: "defaultLocationDisplaySetting")
        currentState = !currentState
        UserDefaults.standard.set(currentState, forKey:"defaultLocationDisplaySetting")
        map.showsUserLocation = currentState
        debugPrint("...to \(map.showsUserLocation)")
    }
    
    // toggle traffic overlay based on switch action and then save this state in UserDefaults to recall next time the app is opened
    @IBAction func toggleShowsTraffic(_ sender: UISwitch) {
        debugPrint("Changing traffic display from \(map.showsTraffic)...")
        var currentState = UserDefaults.standard.bool(forKey: "defaultTrafficSwitchSetting")
        currentState = !currentState
        map.showsTraffic = currentState
        debugPrint("...to \(map.showsTraffic)")
        UserDefaults.standard.set(currentState, forKey:"defaultTrafficSwitchSetting")
    }
    
}

