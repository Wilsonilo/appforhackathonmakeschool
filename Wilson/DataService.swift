//
//  DataService.swift
//  TopCancunFood
//
//  Created by Wilson Muñoz on 3/29/16.
//  Copyright © 2016 Wilson Muñoz. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    static let dataService = DataService()
    
    private var _BASE_REF   = BASE_URL
    private var _IMAGES_REF = BASE_URL.child("images")
    
    var BASE_REF: FIRDatabaseReference {
        return _BASE_REF
    }
    
    var IMAGES_REF: FIRDatabaseReference {
        return _IMAGES_REF
    }
}
