//
//  EFAboutUsVC.swift
//  EasyFind
//
//  Created by Nitin on 17/11/19.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit
import WebKit

class EFAboutUsVC: AbstractViewController, WKNavigationDelegate {
    
    @IBOutlet var myWebKit: WKWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About us"
        myWebKit.navigationDelegate = self
        myWebKit.allowsBackForwardNavigationGestures = true
        loadFromUrl()
        //self.loadFromString()
        
        //self.loadFromFile()
    }
    
    // MARK: - Action
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper
    //
    func loadFromString()
    {
        let htmlStr = """
                            <h1>Hello World</h1>
                            <h2>Hello World</h2>
                            <h3>Hello World</h3>
                            <h4>Hello World</h4>
                            <h5>Hello World</h5>
                            <h6>Hello World</h6>
                      """
        myWebKit.loadHTMLString(htmlStr, baseURL: nil)
    }
    
    func loadFromFile()
    {
        let localfilePath = Bundle.main.url(forResource: "home", withExtension: "html")
        let myRequest = URLRequest(url: localfilePath!)
        myWebKit.load(myRequest)
        //myWebKitView.loadFileURL(<#T##URL: URL##URL#>, allowingReadAccessTo: <#T##URL#>)
        
    }
    
    func loadFromUrl()
    {
        //let url = URL(string: "https://www.youtube.com/watch?v=xQmZSKxOYvs")
        let url = URL(string: "https://www.yelp.com/developers/api_terms")
        //let url = URL(string: "https://www.google.com")
        let urlReq = URLRequest(url: url!)
        myWebKit.load(urlReq)
    }
    
}
