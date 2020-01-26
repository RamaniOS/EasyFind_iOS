//
//  Coordinates+CoreDataClass.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-01-26.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Coordinates)
public class Coordinates: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        self.init(entity: Coordinates.entity(), insertInto: nil)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let lat = try container.decodeIfPresent(Double.self, forKey: .latitude) {
            latitude = lat
        }
        if let long = try container.decodeIfPresent(Double.self, forKey: .longitude) {
            longitude = long
        }
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}
