//
//  ViewController.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-15.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        YelpManager.fetchYelpBusinesses(latitude: 6, longitude: 8)
    }
}

