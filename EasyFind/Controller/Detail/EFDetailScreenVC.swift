//
//  EFDetailScreenVC.swift
//  EasyFind
//
//  Created by Nitin on 17/11/19.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit

class EFDetailScreenVC: AbstractViewController, UIScrollViewDelegate  {
    
    // MARK: - Properties
    let imgArray = NSArray()
    private var business: Businesses?
    var baseModel: DetailM?
       
    class func control(with business: Businesses) -> EFDetailScreenVC {
        let control = self.control as! EFDetailScreenVC
        control.business = business
        return control
    }
    
    @IBOutlet var slideScrollView: UIScrollView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(business?.id)

        fetchList()
     
    }

    // MARK: - Action
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper
    private func fetchList() {
        weak var `self` = self
        YelpManager.fetchYelpBusinessesDetail(with: business?.id ?? "") { (baseModel) in
                self?.baseModel = baseModel
         
            self!.loadTopBannerView()
        }

    }
    
    func loadTopBannerView() {
       
       let pageCount = self.baseModel?.photos!.count
       
       slideScrollView.backgroundColor = UIColor.clear
       slideScrollView.delegate = self
       slideScrollView.isPagingEnabled = true
        slideScrollView.contentSize = CGSize(width: slideScrollView.frame.size.width * CGFloat(pageCount!), height: slideScrollView.frame.size.height)
       slideScrollView.showsHorizontalScrollIndicator = false
        
        for i in 0..<Int(pageCount!) {
            // set banner image...
            let imageView = UIImageView(frame: CGRect(x: self.slideScrollView.frame.size.width * CGFloat(i), y: 0, width: self.slideScrollView.frame.size.width, height: self.slideScrollView.frame.size.height))
            let bannerImage = self.baseModel?.photos![i] as? String ?? ""
            self.loadPic(strUrl: bannerImage, picView: imageView)
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
