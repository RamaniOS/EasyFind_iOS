//
//  ViewController.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-15.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit

class AbstractViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    class var control: AbstractViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: String(describing: self)) as! AbstractViewController
    }
}

