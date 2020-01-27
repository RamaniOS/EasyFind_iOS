//
//  UserStore.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-01-23.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import Foundation

class UserStore {
    
    private init() {}
    
    private static let isLoginKey = "isLoginKey"
    private static let loginEmailKey = "logEmail"
    
    // MARK: - Check login status
    public static var isLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isLoginKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isLoginKey)
        }
    }
    
    public static var loginEmail: String {
        get {
            return UserDefaults.standard.value(forKey: loginEmailKey) as! String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: loginEmailKey)
        }
    }
}
