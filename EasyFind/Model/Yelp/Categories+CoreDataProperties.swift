//
//  Categories+CoreDataProperties.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-01-26.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var alias: String?
    @NSManaged public var title: String?
    @NSManaged public var businesses: Businesses?

}
