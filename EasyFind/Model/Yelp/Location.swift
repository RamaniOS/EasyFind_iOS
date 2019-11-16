//
//  Location.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-15.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import Foundation

struct Location : Codable {
	let address1 : String?
	let address2 : String?
	let address3 : String?
	let city : String?
	let zip_code : String?
	let country : String?
	let state : String?
	let display_address : [String]?
}
