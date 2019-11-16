//
//  SearchTableViewCell.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-15.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    class var reuseId: String {
        return String(describing: self)
    }
    
    var business: Businesses? {
        didSet {
            guard let business = business else { return }
            titleLabel.text = business.name
        }
    }
}
