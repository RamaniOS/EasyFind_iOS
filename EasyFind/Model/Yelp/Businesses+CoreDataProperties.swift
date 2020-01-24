//
//  Businesses+CoreDataProperties.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-01-23.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//
//

import Foundation
import CoreData


extension Businesses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Businesses> {
        return NSFetchRequest<Businesses>(entityName: "Businesses")
    }

    @NSManaged public var alias: String?
    @NSManaged public var display_phone: String?
    @NSManaged public var distance: Double
    @NSManaged public var id: String?
    @NSManaged public var image_url: String?
    @NSManaged public var is_closed: Bool
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var price: String?
    @NSManaged public var rating: Double
    @NSManaged public var review_count: Int16
    @NSManaged public var transactions: [String]?
    @NSManaged public var url: String?
    @NSManaged public var location: Location?

}
