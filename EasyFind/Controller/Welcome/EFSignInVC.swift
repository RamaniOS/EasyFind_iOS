//
//  SigninVC.swift
//  EasyFind
//
//  Created by Nitin on 16/11/19.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit

/// This is the signin class
class EFSignInVC: UIViewController {
    
    // MARK: - Properties
    var passDict = NSDictionary()
    let persistent = PersistenceManager.shared
    var userDefaultBool: Bool!
    
    @IBOutlet var upConta_view: UIView!
    @IBOutlet var inConta_view: UIView!
    @IBOutlet var userN_view: UIView!
    @IBOutlet var passwd_view: UIView!
    @IBOutlet var remembBtn: UIButton!
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var userN_tf: UITextField!
    @IBOutlet var passwd_tf: UITextField!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        setUpUI()
        
        //
        initSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //
        self.view.endEditing(true)
        
        //
        initSetup()
    }
    
    // MARK: - Action
    @IBAction func userNHintBtnClicked(_ sender: Any) {
        self.showAlert(title: "User Name:", message: "nitin")
    }
    
    @IBAction func passwdHintBtnClicked(_ sender: Any) {
        self.showAlert(title: "Password:", message: "c0773774")
    }
    
    @IBAction func rememberBtnClicked(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
        }else{
            sender.isSelected = false
        }
    }
    
    @IBAction func noAccountBtnClicked(_ sender: Any) {
        //
        self.navigateScreen(storyboard: "Main", controller: "EFSignUpVC")
    }
    
    @IBAction func signInBtnClicked(_ sender: Any) {
        //
        if remembBtn.isSelected == true {
            
            UserDefaults.standard.set(userN_tf.text, forKey: "user_name")
            UserDefaults.standard.set(passwd_tf.text, forKey: "password")
        }else{
            UserDefaults.standard.removeObject(forKey: "user_name")
            UserDefaults.standard.removeObject(forKey: "password")
            //            if let appDomain = Bundle.main.bundleIdentifier {
            //                UserDefaults.standard.removePersistentDomain(forName: appDomain)
            //            }
        }
        
        // check validation
        if self.checkTextFields() {
            
            // check if its in userdefault...
            self.checkUserDefaults()
            if userDefaultBool == true {
                //
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "EFTabBarVC") as! EFTabBarVC
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.showAlert(title: "EF", message: "Invalid Info")
            }
            
        }
        
    }
    
    // MARK: - Helper
    func initSetup(){
        //
        if let userName = UserDefaults.standard.string(forKey: "user_name"), let passwd = UserDefaults.standard.string(forKey: "password") {
            //
            remembBtn.isSelected = true
            
            userN_tf.text = userName
            passwd_tf.text = passwd
        }else{
            // reset values
            userN_tf.text = ""
            passwd_tf.text = ""
        }
    }
    
    func setUpUI() {
        //
        userN_view.addBorder(view: userN_view, radius: 7.0, width: 1, color: UIColor.lightGray.cgColor)
        passwd_view.addBorder(view: passwd_view, radius: 7.0, width: 1, color: UIColor.lightGray.cgColor)
        signInBtn.addBorder(view: signInBtn, radius: 7.0, width: 1, color: UIColor.lightGray.cgColor)
        //
        upConta_view.addShadow(view: upConta_view, color: UIColor.hexStringToUIColor(hex: "6D67FD").cgColor, offset: CGSize(width: 0, height: 3), opacity: 0.8, radius: 5)
        inConta_view.addShadow(view: inConta_view, color: UIColor.lightGray.cgColor, offset: CGSize(width: 0, height: 3), opacity: 0.4, radius: 5)
        signInBtn.addShadow(view: signInBtn, color: UIColor.hexStringToUIColor(hex: "6D67FD").cgColor, offset: CGSize(width: 0, height: 3), opacity: 0.8, radius: 5)
        
    }
    
    func checkTextFields() -> Bool {
        
        if userN_tf.text == "" {
            self.showAlert(title: "EF", message: "Username is required.")
            return false
        }
        if passwd_tf.text == "" {
            self.showAlert(title: "EF", message: "Password is required.")
            return false
        }
        
        
        return true
    }
    
    func checkUserDefaults() {
        
        persistent.fetch(type: User.self) { (users) in
            for user in users {
                if self.userN_tf.text == user.userName && self.passwd_tf.text == user.password {

                    //
                    Singelton.sharedObj.userInfoDict = user

                    self.userDefaultBool = true
                }else{
                    self.userDefaultBool = false
                }
            }
        }
       
    }
    
    func readDataInfoFromPlistFile() -> (Bool, String) {
        
        if let plist = Bundle.main.path(forResource: "DataInfo", ofType: "plist")
        {
            if let dict = NSDictionary(contentsOfFile: plist)
            {
                //Reading the users
                if let users = dict["appUsers"] as? [[String: String]]
                {
                    //
                    var strMsg = String()
                    for user in users
                    {
                        
                        let userName = user["username"]!
                        let passwd = user["password"]!
                        
                        // match entered data
                        if(userName != userN_tf.text){
                            strMsg = "Wrong Username"
                        }else if(userName == userN_tf.text && passwd != passwd_tf.text){
                            strMsg = "Wrong Password"
                        }else if(userName == userN_tf.text && passwd == passwd_tf.text) {
                            strMsg = ""
                            return (true, "")
                        }
                    }
                    
                    //
                    return (false, strMsg)
                }
                
            }
        }
        
        return (false, "Invalid information, check again.")
        
    }
    
    
}

