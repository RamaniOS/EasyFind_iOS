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
    func loadPic(strUrl: String, picView: UIImageView){
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        picView.addSubview(activityIndicator)
        activityIndicator.center = picView.center
        activityIndicator.startAnimating()
        
        picView.sd_setImage(with: URL(string: strUrl), completed: nil)
//        picView.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""), options: .progressiveDownload, completed: {(_ image: UIImage?, _ error: Error?, _ cacheType: SDImageCacheType, _ imageURL: URL?) -> Void in
//            activityIndicator.stopAnimating()
//            activityIndicator.removeFromSuperview()
//        })
    }

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
    
    ///
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    ///
    func documentsPathForFileName(name: String) -> String {
           let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
           let path = paths[0] as String;
           let fullPath = path.appending(name)//stringByAppendingPathComponent(name)

           return fullPath
       }

}
