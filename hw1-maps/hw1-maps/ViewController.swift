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
    
    @IBAction func updateMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            map.mapType = .standard
        case 1:
            map.mapType = .hybrid
        case 2:
            map.mapType = .satellite
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let mapTypeIndex = UserDefaults.standard.integer(forKey: "mapType")
        debugPrint(mapTypeIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

