//
//  Action.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-01-23.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import UIKit

class Action {
    private init() {}
    fileprivate static let loginControllerIdentifier = "LoginNavController"
    fileprivate static let homeControllerIdentifier = "EFTabBarVC"
}


class ActionShowLogin: Action {
    static func execute() {
        SceneDelegate.shared?.window?.rootViewController = UIStoryboard.main.instantiateViewController(withIdentifier: loginControllerIdentifier)
    }
}

class ActionShowHome: Action {
    static func execute() {
        SceneDelegate.shared?.window?.rootViewController = UIStoryboard.main.instantiateViewController(withIdentifier: homeControllerIdentifier)
    }
}
