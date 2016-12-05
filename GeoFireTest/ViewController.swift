//
//  ViewController.swift
//  GeoFireTest
//
//  Created by Edward Suczewski on 1/9/16.
//  Copyright © 2016 Edward Suczewski. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        if let name = nameTextField.text {
//            let location = self.currentLocation!
            let location = CLLocation(latitude: 40.9, longitude: -111.8)
            ModelObjectController.createObject(name, location: location, completion: { (error) -> Void in
                if let _ = error {
                    print("Error")
                } else {
                    print("Success")
                }
            })
        }
    }
    
    
    // MARK: view Functions
    override func viewDidLoad() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location)
            self.currentLocation = location
            print(self.currentLocation)
        }
    }


}

