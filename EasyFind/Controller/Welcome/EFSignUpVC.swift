//
//  SignUpVC.swift
//  EasyFind
//
//  Created by Nitin on 16/11/19.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit

/// This is the signup class
class EFSignUpVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet var upConta_view: UIView!
    @IBOutlet var inConta_view: UIView!
    @IBOutlet var userN_view: UIView!
    @IBOutlet var passwd_view: UIView!
    @IBOutlet var confirmPasswd_view: UIView!
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var userN_tf: UITextField!
    @IBOutlet var passwd_tf: UITextField!
    @IBOutlet var confrPasswd_tf: UITextField!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        setUpUI()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //
        self.view.endEditing(true)
        
    }
    
    // MARK: - Action
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpBtnClicked(_ sender: Any) {

        // check validation
        if self.checkTextFields() {
            // check if its in userdefault...
            if self.checkUserDefaults() {
                if let dictArr = UserDefaults.standard.value(forKey: "singnup_arr") as? NSArray {
                    let newDict = ["user_name" : userN_tf.text, "password" : passwd_tf.text]
                    var newArr = NSMutableArray()
                    newArr = dictArr.mutableCopy() as! NSMutableArray
                    newArr.add(newDict)
                    UserDefaults.standard.set(newArr, forKey: "singnup_arr")
                    
                }else {
                    let newDict = ["user_name" : userN_tf.text, "password" : passwd_tf.text]
                    let dictArr = NSMutableArray()
                    dictArr.add(newDict)
                    UserDefaults.standard.set(dictArr, forKey: "singnup_arr")
                }
                
                signUpCompleted()
                
            }else{
                self.showAlert(title: "EF", message: "User Name Already Exists.")
            }
                            
        }else{
            self.showAlert(title: "EF", message: "Invalid Info.")
        }
        
    }
    
    // MARK: - Helper
    func signUpCompleted() {
        //
        let alertController = UIAlertController(title: "EF", message: "SignUp Successfully Done.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
            
            //
            // self.navigateScreen(storyboard: "Main", controller: "MenuVC")
            
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setUpUI() {
        //
        userN_view.addBorder(view: userN_view, radius: 7.0, width: 1, color: UIColor.lightGray.cgColor)
        passwd_view.addBorder(view: passwd_view, radius: 7.0, width: 1, color: UIColor.lightGray.cgColor)
        confirmPasswd_view.addBorder(view: confirmPasswd_view, radius: 7.0, width: 1, color: UIColor.lightGray.cgColor)
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
        if confrPasswd_tf.text == "" {
            self.showAlert(title: "EF", message: "Confirm Password is required.")
            return false
        }
        if passwd_tf.text != confrPasswd_tf.text {
            self.showAlert(title: "EF", message: "Password doesn't match with Confirm Password.")
            return false
        }
        
        return true
    }
    
    func checkUserDefaults() -> Bool {
        
        if let dictArr = UserDefaults.standard.value(forKey: "singnup_arr") as? NSArray {
            
            for dict in dictArr {
                let userDict = dict as! NSDictionary
                if userN_tf.text == userDict["user_name"] as? String {
                    return false
                }
                
            }
        
        }
        
        return true
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


