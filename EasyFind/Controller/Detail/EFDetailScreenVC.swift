//
//  EFDetailScreenVC.swift
//  EasyFind
//
//  Created by Nitin on 17/11/19.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit

class EFDetailScreenVC: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    let imgArray = NSArray()
    @IBOutlet var slideScrollView: UIScrollView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Action
    @IBAction func backBtnClicked(_ sender: Any) {
    }
    
    // MARK: - Helper
    func loadTopBannerView() {
       
       let pageCount : CGFloat = CGFloat(imgArray.count)
       
       slideScrollView.backgroundColor = UIColor.clear
       slideScrollView.delegate = self
       slideScrollView.isPagingEnabled = true
       slideScrollView.contentSize = CGSize(width: slideScrollView.frame.size.width * pageCount, height: slideScrollView.frame.size.height)
       slideScrollView.showsHorizontalScrollIndicator = false
        
        for i in 0..<Int(pageCount) {
            // set banner image...
            let imageView = UIImageView(frame: CGRect(x: self.slideScrollView.frame.size.width * CGFloat(i), y: 0, width: self.slideScrollView.frame.size.width, height: self.slideScrollView.frame.size.height))
            let bannerImage = (imgArray[i]as! NSDictionary)["image"] as? String ?? ""
            //self.loadPic(strUrl: bannerImage, picView: imageView)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            self.slideScrollView.addSubview(imageView)
        
        }
    }
    
    @objc func moveToNextPage (){
        let pageWidth:CGFloat = self.slideScrollView.frame.width
        let maxWidth:CGFloat = CGFloat(Int(pageWidth) * (imgArray.count))
        let contentOffset:CGFloat = self.slideScrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth {
            slideToX = 0
        }
        self.slideScrollView.scrollRectToVisible(CGRect(x: slideToX, y: 0, width: pageWidth, height: self.slideScrollView.frame.height), animated: true)
    
    }
    
    
    
}
