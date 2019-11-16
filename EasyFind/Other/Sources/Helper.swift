//
//  Helper.swift
//  EasyFind
//
//  Created by Nitin on 16/11/19.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {

    ///
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    ///
    func navigateScreen(storyboard: String, controller: String) {
        
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: controller)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
