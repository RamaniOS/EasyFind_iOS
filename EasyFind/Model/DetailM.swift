//
//
//
//  DetailM.swift
//  EasyFind
//
//  Created by Nitin on 17/11/19.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import Foundation
import MapKit

struct DetailM : Codable {

    let photos : [String]?
    let coordinates: cordDetail?
}

struct cordDetail : Codable {

    let latitude : Double?
    let longitude : Double?
}
