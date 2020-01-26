//
//  Businesses+CoreDataClass.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-01-23.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Businesses)
public class Businesses: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case alias, display_phone, distance, id, image_url, is_closed, name, phone, price, rating, review_count, transactions, url, location, categories, coordinates
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        self.init(entity: Businesses.entity(), insertInto: nil)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let ali = try container.decodeIfPresent(String.self, forKey: .alias) {
            alias = ali
        }
        if let display = try container.decodeIfPresent(String.self, forKey: .display_phone) {
            display_phone = display
        }
        if let dist = try container.decodeIfPresent(Double.self, forKey: .distance) {
            distance = dist
        }
        if let id_string = try container.decodeIfPresent(String.self, forKey: .id) {
            id = id_string
        }
        if let image = try container.decodeIfPresent(String.self, forKey: .image_url) {
            image_url = image
        }
        if let closed = try container.decodeIfPresent(Bool.self, forKey: .is_closed) {
            is_closed = closed
        }
        if let nam = try container.decodeIfPresent(String.self, forKey: .name) {
            name = nam
        }
        if let phon = try container.decodeIfPresent(String.self, forKey: .phone) {
            phone = phon
        }
        if let pric = try container.decodeIfPresent(String.self, forKey: .price) {
            price = pric
        }
        if let ratin = try container.decodeIfPresent(Double.self, forKey: .rating) {
            rating = ratin
        }
        if let review = try container.decodeIfPresent(Int16.self, forKey: .review_count) {
            review_count = review
        }
        if let trans = try container.decodeIfPresent([String].self, forKey: .transactions) {
            transactions = trans
        }
        if let ur = try container.decodeIfPresent(String.self, forKey: .url) {
            url = ur
        }
        if let loc = try container.decodeIfPresent(Location.self, forKey: .location) {
            location = loc
        }
        if let cor = try container.decodeIfPresent(Coordinates.self, forKey: .coordinates) {
            coordinates = cor
        }
        if let cat = try container.decodeIfPresent([Categories].self, forKey: .categories) {
            rowCategories = NSOrderedSet(array: cat)
        }
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alias, forKey: .alias)
        try container.encode(display_phone, forKey: .display_phone)
        try container.encode(distance, forKey: .distance)
        try container.encode(id, forKey: .id)
        try container.encode(image_url, forKey: .image_url)
        try container.encode(is_closed, forKey: .is_closed)
        try container.encode(name, forKey: .name)
        try container.encode(phone, forKey: .phone)
        try container.encode(price, forKey: .price)
        try container.encode(rating, forKey: .rating)
        try container.encode(review_count, forKey: .review_count)
        try container.encode(transactions, forKey: .transactions)
        try container.encode(url, forKey: .url)
        try container.encode(location, forKey: .location)
        try container.encode(coordinates, forKey: .coordinates)
        try container.encode(categories, forKey: .categories)
    }
    
    var isFAV: Bool?
    var isFav: Bool? {
        get {
            return isFAV
        }
        set {
            isFAV = newValue
        }
    }
    
    var imageURL: URL? {
        if let url = image_url {
            return URL(string: url)
        }
        return nil
    }
    
    var categories: [Categories]? {
        return rowCategories?.array as? [Categories]
    }
}
