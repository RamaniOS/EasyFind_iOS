//
//  ViewController.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-15.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit
import CDYelpFusionKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchYelpBusinesses(latitude: 43.6451078, longitude: -79.7511923)
        
    }


    fileprivate func fetchYelpBusinesses(latitude: Double, longitude: Double) {
        let apikey = "H7_n0PCOUjVZEMUpa1HCeC6LFPts3LXArEZbjpURqiis-40Cu3wQER1SAENdf4t08Td08hODQQMinYB4U97GpJ4vMptJHQdOz1ELeONy7KxyiQiBB1aLyHUJBczOXXYx"
        let url = URL(string: "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)")
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                print(">>>>>", json, #line, "<<<<<<<<<")
            } catch {
                print("caught")
            }
            }.resume()
    }
}

