//
//  ModelObject.swift
//  GeoFireTest
//
//  Created by Edward Suczewski on 1/9/16.
//  Copyright © 2016 Edward Suczewski. All rights reserved.
//

import Foundation

struct ModelObject: FirebaseType {
    
    private let kName = "name"
    
    var name: String
    var identifier: String?
    
    var endpoint: String {
        return "modelobjects"
    }
    var jsonValue: [String: AnyObject] {
        return[kName: name]
    }
    
    init(name: String, identifier: String? = nil) {
        self.name = name
        self.identifier = identifier
    }
    
    init?(json: [String: AnyObject], identifier: String) {
        guard let name = json[kName] as? String else {
            return nil
        }
        
        self.name = name
        self.identifier = identifier
    }
    
    
    
}