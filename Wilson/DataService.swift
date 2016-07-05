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
    
    private var _BASE_REF   = Firebase(url: "\(BASE_URL)")
    private var _IMAGES_REF = Firebase(url: "\(BASE_URL)/images")
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var IMAGES_REF: Firebase {
        return _IMAGES_REF
    }
}
