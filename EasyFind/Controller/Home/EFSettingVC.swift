//
//  EFSettingVC.swift
//  EasyFind
//
//  Created by Nitin on 17/11/19.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit
import MessageUI

class EFSettingVC: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action

    @IBAction func callUsBtnClicked(_ sender: Any) {
        if let url = URL(string: "tel://+0000000)"), UIApplication.shared.canOpenURL(url){
            if #available(iOS 10, *)
            {
                UIApplication.shared.open(url)
            }
            else
            {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func emailUsBtnClicked(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
        
            let picker = MFMailComposeViewController()
            picker.mailComposeDelegate = self
            picker.setSubject("Subject")
            picker.setMessageBody("Type Msg...", isHTML: true)
        
            present(picker, animated: true, completion: nil)
        }else{
            self.showAlert(title: "EF", message: "Not allowed")
        }
    }
    
    @IBAction func aboutUsBtnClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EFAboutUsVC") as! EFAboutUsVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MFMailComposeViewControllerDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
}
