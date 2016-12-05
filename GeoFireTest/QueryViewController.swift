//
//  QueryViewController.swift
//  GeoFireTest
//
//  Created by Edward Suczewski on 1/9/16.
//  Copyright © 2016 Edward Suczewski. All rights reserved.
//

import UIKit

class QueryViewController: UIViewController, UITableViewDataSource {
    
    var modelObjects: [ModelObject] = []

    @IBOutlet weak var tableView: UITableView!
    @IBAction func searchButtonTapped(sender: UIButton) {
        if let latitude = CLLocationDegrees(latitudeTextField.text!) {
            if let longitude = CLLocationDegrees(longitudeTextField.text!) {
                let center = CLLocation(latitude: latitude, longitude: longitude)
                let locationBase = FirebaseController.base.childByAppendingPath("modelobjects")
                let geoFire = GeoFire(firebaseRef: locationBase)
                let circleQuery = geoFire.queryAtLocation(center, withRadius: 1.0)
                circleQuery.observeSingleEventOfTypeValue({ (json) -> Void in
                    let keys = Array(json.keys)
                    for key in keys {
                        if let identifier = key as? String {
                            ModelObjectController.modelObjectWithIdentifier(identifier, completion: { (modelObject) -> Void in
                                print("test")
                                if let modelObject = modelObject {
                                    self.modelObjects.append(modelObject)
                                }
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.tableView.reloadData()
                                })
                            })
                        }
                    }
                })
                
            }
        }

    }
    
    @IBOutlet weak var latitudeTextField: UITextField!
    
    @IBOutlet weak var longitudeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelObjects.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("modelObjectCell", forIndexPath: indexPath)
        cell.textLabel?.text = modelObjects[indexPath.row].name
        return cell
    }
    
    


}
