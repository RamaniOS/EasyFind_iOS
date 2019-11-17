//
//  LocalStore.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-17.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//


import UIKit

extension NSNotification.Name {
    static let favRefreshKey = Notification.Name("favRefreshKey")
}

class NotificationStore {
    
    private init() {}
    
    static func refreshFav() {
        NotificationCenter.default.post(name: .favRefreshKey, object: nil)
    }
}
