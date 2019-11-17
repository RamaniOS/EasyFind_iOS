//
//  Helper.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-17.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    static func applyGradient(to button: UIButton) {
        let layer = CAGradientLayer()
        layer.name = "CAGradientLayer"
        layer.frame.size = button.frame.size
        layer.frame.origin = CGPoint(x: 0, y: 0)
        let color0 = UIColor(red: 246/255, green: 28/255, blue: 91/255, alpha: 0.95).cgColor
        let color1 = UIColor(red: 248/255, green: 172/255, blue: 117/255, alpha: 0.95).cgColor
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.colors = [color0, color1]
        button.layer.insertSublayer(layer, at: 0)
    }
}
