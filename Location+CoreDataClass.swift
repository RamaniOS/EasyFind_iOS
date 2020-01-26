//
//  Location+CoreDataClass.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-01-23.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city, country, display_address, state, zip_code
    }
    
    convenience init?(business: Businesses, insertInto context: NSManagedObjectContext) {
        self.init(entity: Location.entity(), insertInto: context)
        if let location = business.location {
            address1 = location.address1
            address2 = location.address2
            address3 = location.address3
            city = location.city
            country = location.country
            display_address = location.display_address
            state = location.state
            zip_code = location.zip_code
        }
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        self.init(entity: Location.entity(), insertInto: nil)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let add = try container.decodeIfPresent(String.self, forKey: .address1) {
            address1 = add
        }
        if let add = try container.decodeIfPresent(String.self, forKey: .address2) {
            address2 = add
        }
        if let add = try container.decodeIfPresent(String.self, forKey: .address3) {
            address3 = add
        }
        if let ci = try container.decodeIfPresent(String.self, forKey: .city) {
            city = ci
        }
        if let cou = try container.decodeIfPresent(String.self, forKey: .country) {
            country = cou
        }
        if let display = try container.decodeIfPresent([String].self, forKey: .display_address) {
            display_address = display
        }
        if let sta = try container.decodeIfPresent(String.self, forKey: .state) {
            state = sta
        }
        if let zip = try container.decodeIfPresent(String.self, forKey: .zip_code) {
            zip_code = zip
        }
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address1, forKey: .address1)
        try container.encode(address2, forKey: .address2)
        try container.encode(address3, forKey: .address3)
        try container.encode(city, forKey: .city)
        try container.encode(country, forKey: .country)
        try container.encode(display_address, forKey: .display_address)
        try container.encode(state, forKey: .state)
        try container.encode(zip_code, forKey: .zip_code)
    }
}
