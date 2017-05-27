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
    @IBOutlet weak var toggleTrackingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "updateMap"), object: nil, queue: OperationQueue.main, using: { (notification) in
            // update map view
            let latitude = notification.userInfo?["latitude"] as? Double ?? 0.0
            let longitude = notification.userInfo?["longitude"] as? Double ?? 0.0
            let newBreadCrumb = BreadCrumb(latitude: latitude, longitude: longitude)
            
            self.map.addAnnotation(newBreadCrumb)
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        
        // Pull settings saved in UserDefualts and store in local constants
        let latitude = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLatitude"))
        let longitude = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLongitude"))
        let latDelta = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLatDelta"))
        let longDelta = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLongDelta"))
        var mapIndex = UserDefaults.standard.integer(forKey: "mapType")
        var trafficSwitchSetting = UserDefaults.standard.bool(forKey: "defaultTrafficSetting")
        var locationSwitchSetting = UserDefaults.standard.bool(forKey: "defaultLocationSetting")
        var trackButtonSetting = UserDefaults.standard.bool(forKey: "defaultTrackingSetting")

        // Check iCould for UI state changes from other devices and overwrite local (ie outdated) states
        if let cloudMapIndex = NSUbiquitousKeyValueStore.default().object(forKey: "mapType") {
            mapIndex = cloudMapIndex as! Int
        }
        if let cloudTrafficSwitchSetting = NSUbiquitousKeyValueStore.default().object(forKey: "defaultTrafficSetting") {
            trafficSwitchSetting = cloudTrafficSwitchSetting as! Bool
        }
        if let cloudLocationSwitchSetting = NSUbiquitousKeyValueStore.default().object(forKey: "defaultLocationSetting") {
            locationSwitchSetting = cloudLocationSwitchSetting as! Bool
        }
        if let cloudTrackButtonSetting = NSUbiquitousKeyValueStore.default().object(forKey: "defaultTrackingSetting") {
            trackButtonSetting = cloudTrackButtonSetting as! Bool
        }
        
        // Define last map position and index
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region = MKCoordinateRegion(center: coordinates, span: span)

        // Restore map's index, position, traffic and location settings
        map.setRegion(region, animated: true)
        map.showsTraffic = trafficSwitchSetting
        map.showsUserLocation = locationSwitchSetting
        updateMapType(index: mapIndex)
        
        //Restore previous annotation pins (IE breadCrumbs)
        if let delegate = map.delegate as? MapDelegate {
            let breadCrumbs: [BreadCrumb] = delegate.fetchBreadCrumbsArray()
            map.addAnnotations(breadCrumbs)
        }
        
        // Restore other UI appearances
        mapSegmentedControl.selectedSegmentIndex = mapIndex
        trafficSwitch.isOn = trafficSwitchSetting
        locationSwitch.isOn = locationSwitchSetting
        toggleTrackingButton.isSelected = trackButtonSetting
        
        if let delegate = map.delegate as? MapDelegate {
            delegate.locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let delegate = map.delegate as? MapDelegate {
            delegate.locationManager.stopUpdatingLocation()
        }
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
    
    // update the map type and save state in User Defaults + iCloud
        @IBAction func updateSegmentIndex(_ sender: UISegmentedControl) {
        updateMapType(index: sender.selectedSegmentIndex)
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey:"mapType")
        NSUbiquitousKeyValueStore().set(sender.selectedSegmentIndex, forKey: "mapType")
        NSUbiquitousKeyValueStore().synchronize()
    }
    
    // toggle location display and save  state in User Defaults + iCloud
    @IBAction func toggleShowsLocation(_ sender: UISwitch) {
        debugPrint("Changing location   from \(map.showsUserLocation)...")
        let currentState = map.showsUserLocation
        let newState = !currentState
        map.showsUserLocation = newState
        UserDefaults.standard.set(newState, forKey:"defaultLocationSetting")
        NSUbiquitousKeyValueStore().set(newState, forKey: "defaultLocationSetting")
        NSUbiquitousKeyValueStore().synchronize()
        debugPrint("...to \(map.showsUserLocation)")
    }
    
    // toggle traffic overlay and save state in User Defaults + iCloud
    @IBAction func toggleShowsTraffic(_ sender: UISwitch) {
        debugPrint("Changing traffic display from \(map.showsTraffic)...")
        let currentState = map.showsTraffic
        let newState = !currentState
        map.showsTraffic = newState
        debugPrint("...to \(map.showsTraffic)")
        UserDefaults.standard.set(newState, forKey:"defaultTrafficSetting")
        NSUbiquitousKeyValueStore().set(newState, forKey: "defaultTrafficSetting")
        NSUbiquitousKeyValueStore().synchronize()
    }
    
    // toggle automatic pin drops (at distances interval equal to LocationManager.distanceFilter) and save state in User Defaults + iCloud
    @IBAction func toggleTrackingButton(_ sender: Any) {
        let currentState = toggleTrackingButton.isSelected
        let newState = !currentState
        toggleTrackingButton.isSelected = newState
        UserDefaults.standard.set(newState, forKey: "defaultTrackingSetting")
        NSUbiquitousKeyValueStore().set(newState, forKey: "defaultTrackingSetting")
        NSUbiquitousKeyValueStore().synchronize()
    }

    // Delete all map annotations on button tap
    @IBAction func clearBreadCrumbs(_ sender: UIButton) {
        debugPrint("attemting to clear all breadCrumbs...")
        if let delegate = map.delegate as? MapDelegate {
            let currentBreadCrumbs = map.annotations
            map.removeAnnotations(currentBreadCrumbs)
            delegate.saveBreadCrumbsArray(breadCrumbsArray: [])
            debugPrint("successfully cleared \(currentBreadCrumbs)")
        }
        
    }
}
