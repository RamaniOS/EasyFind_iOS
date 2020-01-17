//
//  User+CoreDataProperties.swift
//  
//
//  Created by Ramanpreet Singh on 2020-01-17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var imagePath: String?
    @NSManaged public var userName: String?
    @NSManaged public var password: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?

}
