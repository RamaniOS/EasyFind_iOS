//
//  YelpManager.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-15.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//
import Alamofire

class YelpManager {
 
    static func fetchYelpBusinesses(latitude: Double, longitude: Double) {
        
        let parameters: Parameters = ["location": "Brampton"]
        let url = URL(string: "https://api.yelp.com/v3/businesses/search")
        
        APIManager.requestWith(url!, parameters: parameters) { (base: BaseBusiness?) in
            print(base?.total)
        }
    }
       
}
