//
//  Businesses.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-15.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import Foundation

struct Businesses : Codable {
	let id : String?
	let alias : String?
	let name : String?
	let image_url : String?
	let is_closed : Bool?
	let url : String?
	let review_count : Int?
	let categories : [Categories]?
	let rating : Double?
	let coordinates : Coordinates?
	let transactions : [String]?
	let price : String?
	let location : Location?
	let phone : String?
	let display_phone : String?
	let distance : Double?
}
