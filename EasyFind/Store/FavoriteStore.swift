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
        
    static private var list: [Businesses] = []
    
    static var fetchAllFav: [Businesses] {
        return list.reversed()
    }
    
    static func addToFav(with business: Businesses) {
        if list.contains(where: {$0.id == business.id}) {
            return // IF already exist
        }
        list.append(business)
    }
    
    static func removeFromFav(with business: Businesses) {
        list.removeAll(where: {$0.id == business.id})
    }
    
    static func performLogout() {
        list.removeAll()
    }
}
