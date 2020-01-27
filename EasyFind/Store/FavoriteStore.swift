//
//  LocalStore.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-17.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import Foundation

class FavoriteStore {
    
    private init() {}
        
    private static let context = PersistenceManager.shared.context
    
    static func fetchAllFav(comp: @escaping (_ business: [Businesses]) -> Void) {
        PersistenceManager.shared.fetch(type: Businesses.self) { (businesses) in
            comp(businesses)
        }
    }
    
    static func addToFav(with business: Businesses) {
        _ = Businesses(business: business, insertInto: context)
        do {
            try context.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    static func removeFromFav(with business: Businesses) {
        
    }
    
    static func performLogout() {
        PersistenceManager.shared.clean(type: Businesses.self)
    }
}
