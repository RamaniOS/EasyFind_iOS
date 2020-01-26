//
//  Location+CoreDataProperties.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-01-23.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var address1: String?
    @NSManaged public var address2: String?
    @NSManaged public var address3: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var display_address: [String]?
    @NSManaged public var state: String?
    @NSManaged public var zip_code: String?
    @NSManaged public var businesses: Businesses?

}
