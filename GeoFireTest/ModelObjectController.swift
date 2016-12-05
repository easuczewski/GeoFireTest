//
//  ModelObjectController.swift
//  GeoFireTest
//
//  Created by Edward Suczewski on 1/9/16.
//  Copyright © 2016 Edward Suczewski. All rights reserved.
//

import Foundation

class ModelObjectController {
    
    // Create
    static func createObject(name: String, location: CLLocation, completion:(error: NSError?) -> Void) {
        var modelObject =  ModelObject(name: name)
        modelObject.saveAtLocation(location, completion: { (error) -> Void in
        })
    }
    
    // Read
    static func modelObjectWithIdentifier(identifier: String, completion: (modelObject: ModelObject?) -> Void) {
        FirebaseController.dataAtEndpoint("modelobjects/\(identifier)") { (data) -> Void in
            if let data = data as? [String: AnyObject] {
                let modelObject = ModelObject(json: data, identifier: identifier)
                completion(modelObject: modelObject)
            }
        }
    }

}



