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
    
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var toggleTrackingButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    // save map position in User Defaults every time the MapView's viewable area changes
    func mapView(_ map: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let newLatitude = map.region.center.latitude
        let newLongitude = map.region.center.longitude
        let newLatDelta = map.region.span.latitudeDelta
        let newLongDelta = map.region.span.longitudeDelta
        
        UserDefaults.standard.set(newLatitude, forKey:"defaultLatitude")
        UserDefaults.standard.set(newLongitude, forKey:"defaultLongitude")
        UserDefaults.standard.set(newLatDelta, forKey:"defaultLatDelta")
        UserDefaults.standard.set(newLongDelta, forKey:"defaultLongDelta")
        
        debugPrint("region changed...")
        debugPrint("latitude \(newLatitude)")
        debugPrint("longitude: \(newLongitude)")
        debugPrint("latDelta: \(newLatDelta)")
        debugPrint("longDelta \(newLongDelta)")

    }
    
    //request location tracking authorization
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
       
        let locationAuthoriationStatus = CLLocationManager.authorizationStatus()
        
        switch locationAuthoriationStatus {
            
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            
            case .denied:
                debugPrint("user denied location tracking")
                locationSwitch.isOn = false
                
                let requestAlert = UIAlertController(title: "Oops", message: "This feature requires location to be enabled.", preferredStyle: UIAlertControllerStyle.alert)
                
                requestAlert.addAction(UIAlertAction(title: "Go to settings...", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction) in
                    
                    let settingsPath = UIApplicationOpenSettingsURLString
                    let settingsURL = URL(string: settingsPath)!
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    
                }))
                
                UIApplication.shared.keyWindow?.rootViewController?.present(requestAlert, animated: false, completion: nil) // I copy pasted this...have no idea how it makes UIViewController to present the alert, nor if this is a bad practice
                
            
            
            case .authorizedWhenInUse:
                debugPrint("location authorization already received from user")
            
            default:
                debugPrint("location auth error or resitricted by parental controls")
        }
        
        locationManager.delegate = self
        //locationManager.startUpdatingLocation()
        //locationManager.stopUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5.0
    }
    
    // method is called every time the user's location changes >= the locationManager.distanceFilter value. If the user has enabled tracking, the method will drop a pin at the current location and add it to an array saved on disk.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if toggleTrackingButton.isSelected {
        
            debugPrint("called didUpdateLocations...")
        
            let newLocationPin = MKPointAnnotation()
            let newUserLocation: CLLocation = locations[0]
        
            let newUserLatitude = newUserLocation.coordinate.latitude
            let newUserLongitude = newUserLocation.coordinate.longitude
            
            let newBreadCrumb = BreadCrumb(latitude: newUserLatitude, longitude: newUserLongitude)
            
            newLocationPin.coordinate = newBreadCrumb.coordinate
            map.addAnnotation(newBreadCrumb)
            debugPrint("Pin dropped at...\(newLocationPin)")
            
            var breadCrumbs = fetchBreadCrumbsArray()
            breadCrumbs.append(newBreadCrumb)
            debugPrint("total number of pins now at \(breadCrumbs.count)")
            saveBreadCrumbsArray(breadCrumbsArray: breadCrumbs)

        } else {
            debugPrint("Location changed but tracking is disabled by user")
        }
    }

    func breadCrumbsFilePath() -> String {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let result = urls[urls.count-1]
        let resultURL = result.appendingPathComponent("BreadCrumbs.data")
        return resultURL.path
    }
    
    func saveBreadCrumbsArray(breadCrumbsArray: [BreadCrumb]) {
        NSKeyedArchiver.archiveRootObject(breadCrumbsArray, toFile: breadCrumbsFilePath())
    }
    
    func fetchBreadCrumbsArray() -> [BreadCrumb] {
        let breadCrumbsURLPath = breadCrumbsFilePath()
        let savedBreadCrumbsArray = NSKeyedUnarchiver.unarchiveObject(withFile: breadCrumbsURLPath)
        if let breadCrumbs = savedBreadCrumbsArray as? [BreadCrumb] {
            return breadCrumbs
        } else {
            return []
        }
    }
}
