//
//  DetailViewController.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-17.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit

class DetailViewController: AbstractViewController {

    private var business: Businesses?
    
    class func control(with business: Businesses) -> DetailViewController {
        let control = self.control as! DetailViewController
        control.business = business
        return control
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(business?.id)
    }
}
