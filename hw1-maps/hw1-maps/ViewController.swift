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
        debugPrint(mapIndex)
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

