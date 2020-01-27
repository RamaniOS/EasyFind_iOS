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
    
    // MARK: - Properties
    @IBOutlet weak var aboutUsButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var callUsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet var img_view: UIImageView!
    @IBOutlet var name_lbl: UILabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    private func initViews() {
        title = "Settings"
        Helper.applyGradient(to: aboutUsButton)
        Helper.applyGradient(to: emailButton)
        Helper.applyGradient(to: callUsButton)
        Helper.applyGradient(to: logoutButton)
        
        guard let user = Singelton.sharedObj.userInfoDict else { return }
        //
        let possibleOldImagePath = user.imagePath
        let oldFullPath = self.documentsPathForFileName(name: possibleOldImagePath)
        let oldImageData = NSData(contentsOfFile: oldFullPath)
        // here is your saved image:
        img_view.image = UIImage(data: oldImageData! as Data)
        let welcome = "Welcome \(user.userName)"
        name_lbl.text = welcome
    }
    
    // MARK: - Action
    @IBAction func callUsBtnClicked(_ sender: Any) {
        if let url = URL(string: "tel://+0000000)"), UIApplication.shared.canOpenURL(url){
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
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
        } else {
            showAlert(title: "EF", message: "Not allowed")
        }
    }
    
    @IBAction func aboutUsBtnClicked(_ sender: Any) {
        navigationController?.pushViewController(EFAboutUsVC.control, animated: true)
    }
    
    // MFMailComposeViewControllerDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        FavoriteStore.performLogout()
        UserStore.isLogin = false
        ActionShowLogin.execute()
    }
}
