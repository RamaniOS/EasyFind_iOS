//
//  SearchTableViewCell.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-15.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var typesLabel: UILabel!
    @IBOutlet weak private var starView: CosmosView!
    @IBOutlet weak private var ratingLabel: UILabel!
    @IBOutlet weak private var imgView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    static var reuseId: String {
        return String(describing: self)
    }
    
    var business: Businesses? {
        didSet {
            guard let business = business else { return }
            business.isFav = PersistenceManager.shared.checkIsExist(at: business) 
            titleLabel.text = business.name
            imgView.sd_setImage(with: business.imageURL)
            starView.rating = business.rating
            ratingLabel.text = "\(business.review_count) Review"
            priceLabel.text = business.price
            if let location = business.location, let address =  location.address1, let city =  location.city{
                addressLabel.text = "\(address), \(city)"
            }
            if let category = business.categories {
                var types = ""
                for index in 0...category.count - 1 {
                    types.append(category[index].title!)
                    if index < category.count - 1 {
                        types.append(", ")
                    }
                }
                typesLabel.text = types
            }
            favButton.image = business.isFav ? #imageLiteral(resourceName: "Fav") : #imageLiteral(resourceName: "UnFav")
            favButton.actionBlock { [weak self] in
                guard let `self` = self else { return }
                business.isFav = !business.isFav
                self.favButton.image = business.isFav ? #imageLiteral(resourceName: "Fav") : #imageLiteral(resourceName: "UnFav")
                if business.isFav {
                    FavoriteStore.addToFav(with: business)
                } else {
                    FavoriteStore.removeFromFav(with: business)
                }
                NotificationStore.refreshFav()
            }
        }
    }
    
    static var cellHeight: CGFloat {
        return UIScreen.mainSize.width * 0.4
    }
}
