//
//  FirebaseController.swift
//  GeoFireTest
//
//  Created by Edward Suczewski on 1/9/16.
//  Copyright © 2016 Edward Suczewski. All rights reserved.
//

import Foundation
import Firebase

class FirebaseController {
    
    // MARK: Properties
    static let base = Firebase(url: "https://geofiretest1.firebaseio.com")
    
    // MARK: Methods
    static func dataAtEndpoint(endpoint: String, completion: (data: AnyObject?) -> Void) {
        let baseForEndpoint = FirebaseController.base.childByAppendingPath(endpoint)
        baseForEndpoint.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.value is NSNull {
                completion(data: nil)
            } else {
                completion(data: snapshot.value)
            }
        })
    }
    
    static func observeDataAtEndpoint(endpoint: String, completion: (data: AnyObject?) -> Void) {
        let baseForEndpoint = FirebaseController.base.childByAppendingPath(endpoint)
        baseForEndpoint.observeEventType(.Value, withBlock: { (snapshot) in
            if snapshot.value is NSNull {
                completion(data: nil)
            } else {
                completion(data: snapshot.value)
            }
        })
    }
}

// MARK: Protocol - FirebaseType
protocol FirebaseType {
    var identifier: String? { get set }
    var endpoint: String { get }
    var jsonValue: [String: AnyObject] { get }
    
    init?(json: [String: AnyObject], identifier: String)
    
    mutating func saveAtLocation(location: CLLocation, completion: (error: NSError?) -> Void)
    mutating func delete(completion: (error: NSError?) -> Void)
}

extension FirebaseType {
    
    mutating func saveAtLocation(location: CLLocation, completion: (error: NSError?) -> Void) {
        var endpointBase: Firebase
        var key: String
        if let childID = self.identifier {
            endpointBase = FirebaseController.base.childByAppendingPath(endpoint).childByAppendingPath(childID)
                key = childID
        } else {
            endpointBase = FirebaseController.base.childByAppendingPath(endpoint).childByAutoId()
            self.identifier = endpointBase.key
            key = self.identifier!
        }
        let locationBase = FirebaseController.base.childByAppendingPath(endpoint)
        let geoFire = GeoFire(firebaseRef: locationBase)
        geoFire.setLocation(location, forKey: key)
        
        endpointBase.updateChildValues(self.jsonValue) { (error, _) -> Void in
            if let error = error {
                completion(error: error)
            } else {
                completion(error: nil)
            }
        }
        
    }
    
    func delete(completion: (error: NSError?) -> Void) {
        let endpointBase: Firebase = FirebaseController.base.childByAppendingPath(endpoint).childByAppendingPath(self.identifier)
        endpointBase.removeValueWithCompletionBlock { (error, _) -> Void in
            completion(error: error)
        }
    }
}
