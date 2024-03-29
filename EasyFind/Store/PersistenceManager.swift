//
//  PersistenceManager.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-01-17.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import Foundation
import CoreData

class PersistenceManager {
    
    private init() {}
    
    static let shared = PersistenceManager()
    
    static func printPath() {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "EasyFind")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(type: T.Type, comp: @escaping ([T]) -> Void) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        request.includesSubentities = false
        do {
            let objects = try context.fetch(request)
            comp(objects)
        } catch {
            comp([])
        }
    }
    
    func checkIsExist(at object: Businesses) -> Bool {
        let request: NSFetchRequest<Businesses> = Businesses.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", object.id!)
        request.includesSubentities = false
        do {
            let objects = try context.fetch(request)
            for obj in objects where obj == object {
                return true
            }
        } catch {
            return false
        }
        return false
    }
    
    func delete(at id: String) -> Bool {
        let request: NSFetchRequest<Businesses> = Businesses.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        request.includesSubentities = false
        do {
            let objects = try context.fetch(request)
            if objects.count > 0 {
                context.delete(objects[0]) // we know only one object for one id
                try context.save()
                return true
            }
        } catch {
            return false
        }
        return false
    }
    
    func update<T: NSManagedObject>(type: T.Type, comp: @escaping(_: Bool) -> Void) {
        
    }
    
    func clean<T: NSManagedObject>(type: T.Type) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        do {
            let objects = try context.fetch(request)
            for object in objects {
                context.delete(object)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
