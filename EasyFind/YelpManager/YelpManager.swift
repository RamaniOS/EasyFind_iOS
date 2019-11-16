//
//  YelpManager.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-15.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//
import Alamofire

class YelpManager {
 
    static func fetchYelpBusinesses(with location: String, completion: @escaping(_: BaseBusiness?) -> Void) {
        
        let parameters: Parameters = ["location": location]
        
        let url = URL(string: "https://api.yelp.com/v3/businesses/search")
        
        APIManager.requestWith(url!, parameters: parameters) { (base: BaseBusiness?) in
            guard let baseModel = base else {
                completion(nil)
                return
            }
            completion(baseModel)
        }
    }
       
}
