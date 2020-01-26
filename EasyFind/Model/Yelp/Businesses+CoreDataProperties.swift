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
    @NSManaged public var rowCategories: NSOrderedSet?
    @NSManaged public var coordinates: Coordinates?

}

// MARK: Generated accessors for categories
extension Businesses {

    @objc(insertObject:inCategoriesAtIndex:)
    @NSManaged public func insertIntoCategories(_ value: Categories, at idx: Int)

    @objc(removeObjectFromCategoriesAtIndex:)
    @NSManaged public func removeFromCategories(at idx: Int)

    @objc(insertCategories:atIndexes:)
    @NSManaged public func insertIntoCategories(_ values: [Categories], at indexes: NSIndexSet)

    @objc(removeCategoriesAtIndexes:)
    @NSManaged public func removeFromCategories(at indexes: NSIndexSet)

    @objc(replaceObjectInCategoriesAtIndex:withObject:)
    @NSManaged public func replaceCategories(at idx: Int, with value: Categories)

    @objc(replaceCategoriesAtIndexes:withCategories:)
    @NSManaged public func replaceCategories(at indexes: NSIndexSet, with values: [Categories])

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Categories)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Categories)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSOrderedSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSOrderedSet)

}
