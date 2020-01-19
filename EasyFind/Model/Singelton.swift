//
//  Singelton.swift
//  EasyFind
//
//  Created by Nitin on 16/11/19.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import Foundation
import MapKit

class Singelton {
    
    static let sharedObj = Singelton()
    
    var userInfoDict: User?
    var currLoc = CLLocation()
}
