//
//  Categories+CoreDataClass.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-01-26.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Categories)
public class Categories: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case alias, title
    }
    
    convenience init?(category: Categories, insertInto context: NSManagedObjectContext) {
        self.init(entity: Categories.entity(), insertInto: context)
        alias = category.alias
        title = category.title
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        self.init(entity: Categories.entity(), insertInto: nil)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let al = try container.decodeIfPresent(String.self, forKey: .alias) {
            alias = al
        }
        if let ti = try container.decodeIfPresent(String.self, forKey: .title) {
            title = ti
        }
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alias, forKey: .alias)
        try container.encode(title, forKey: .title)
    }
}
