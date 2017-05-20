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
        let mapIndex = UserDefaults.standard.integer(forKey: "mapType")
        let latitude = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLatitude"))
        let longitude = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLongitude"))
        let latDelta = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLatDelta"))
        let longDelta = CLLocationDegrees(UserDefaults.standard.integer(forKey: "defaultLongDelta"))
        let trafficSwitchSetting = UserDefaults.standard.bool(forKey: "defaultTrafficSetting")
        let locationSwitchSetting = UserDefaults.standard.bool(forKey: "defaultLocationSetting")
        let trackButtonSetting = UserDefaults.standard.bool(forKey: "defaultTrackingSetting")


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
    
    // update the map type and save state in User Defaults
        @IBAction func updateSegmentIndex(_ sender: UISegmentedControl) {
        updateMapType(index: sender.selectedSegmentIndex)
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey:"mapType")
    }
    
    // toggle location display and save  state in User Defaults
    @IBAction func toggleShowsLocation(_ sender: UISwitch) {
        debugPrint("Changing location   from \(map.showsUserLocation)...")
        let currentState = map.showsUserLocation
        let newState = !currentState
        map.showsUserLocation = newState
        UserDefaults.standard.set(newState, forKey:"defaultLocationSetting")
        debugPrint("...to \(map.showsUserLocation)")
    }
    
    // toggle traffic overlay and save state in User Defaults
    @IBAction func toggleShowsTraffic(_ sender: UISwitch) {
        debugPrint("Changing traffic display from \(map.showsTraffic)...")
        let currentState = map.showsTraffic
        let newState = !currentState
        map.showsTraffic = newState
        debugPrint("...to \(map.showsTraffic)")
        UserDefaults.standard.set(newState, forKey:"defaultTrafficSetting")
    }
    
    // toggle automatic pin drops (at distances interval equal to LocationManager.distanceFilter) and save state in User Defaults
    @IBAction func toggleTrackingButton(_ sender: Any) {
        let currentState = toggleTrackingButton.isSelected
        let newState = !currentState
        toggleTrackingButton.isSelected = newState
        UserDefaults.standard.set(newState, forKey: "defaultTrackingSetting")
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
