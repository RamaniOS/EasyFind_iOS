//
//  SearchTableViewCell.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-15.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit
import SDWebImage

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak private var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    class var reuseId: String {
        return String(describing: self)
    }
    
    var business: Businesses? {
        didSet {
            guard let business = business else { return }
            titleLabel.text = business.name
            imgView.sd_setImage(with: business.imageURL)
        }
    }
    
    static var aspect: CGFloat = 0.25
    
    class var aspectRatio: CGFloat {
        get {
            return aspect
        }
        set {
            aspect = newValue
        }
    }
    
    class var cellHeight: CGFloat {
        return UIScreen.mainSize.width * aspectRatio
    }
}
