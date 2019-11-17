//
//  SignUpVC.swift
//  EasyFind
//
//  Created by Nitin on 16/11/19.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit
import CoreLocation

/// This is the signup class
class EFSignUpVC: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Properties
    let picker = UIImagePickerController()
    var locationManager: CLLocationManager! = nil
    var currLoc = CLLocation()
    var passDict = NSDictionary()
    
    @IBOutlet var upConta_view: UIView!
    @IBOutlet var inConta_view: UIView!
    @IBOutlet var userN_view: UIView!
    @IBOutlet var passwd_view: UIView!
    @IBOutlet var confirmPasswd_view: UIView!
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var userN_tf: UITextField!
    @IBOutlet var passwd_tf: UITextField!
    @IBOutlet var confrPasswd_tf: UITextField!
    @IBOutlet var img_view: UIImageView!
    
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
    @IBAction func cameraBtnClicked(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController(title: "EF", message: "", preferredStyle: .actionSheet)
        let galleryAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Select Photo from Gallery", comment: ""), style: .default) { action -> Void in
           
            self.picker.delegate = self
            self.picker.allowsEditing = true
            self.picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(self.picker, animated: true, completion: nil)
            
        }
        let cameraAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                self.picker.delegate = self
                self.picker.allowsEditing = true
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.present(self.picker,animated: true,completion: nil)
                
            }else{
                self.noCamera()
            }
        }
        let cancelAction: UIAlertAction = UIAlertAction(title:  NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in }
        
        actionSheetController.addAction(galleryAction)
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(cancelAction)
        
        // Remove arrow from action sheet.
        actionSheetController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        
        //For set action sheet to middle of view.
        actionSheetController.popoverPresentationController?.sourceView = self.view
        actionSheetController.popoverPresentationController?.sourceRect = self.view.bounds
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpBtnClicked(_ sender: Any) {

        // check validation
        if self.checkTextFields() {
            // check if its in userdefault...
            if self.checkUserDefaults() {
                if let dictArr = UserDefaults.standard.value(forKey: "singnup_arr") as? NSArray {
                    let newDict = ["user_name" : userN_tf.text ?? "", "password" : passwd_tf.text ?? "", "current_loc" : currLoc, "user_img": img_view.image ?? nil] as [String : Any]
                    passDict = newDict as NSDictionary
                    var newArr = NSMutableArray()
                    newArr = dictArr.mutableCopy() as! NSMutableArray
                    newArr.add(newDict)
                    UserDefaults.standard.set(newArr, forKey: "singnup_arr")
                    
                }else {
                    let newDict = ["user_name" : userN_tf.text ?? "", "password" : passwd_tf.text ?? "", "user_img": img_view.image ?? nil] as [String : Any]
                    passDict = newDict as NSDictionary
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            vc.userInfoDict = self.passDict
            
            self.navigationController?.pushViewController(vc, animated: true)
            
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
        img_view.addBorder(view: img_view, radius: 75.0, width: 2, color: UIColor.white.cgColor)
        //
        upConta_view.addShadow(view: upConta_view, color: UIColor.hexStringToUIColor(hex: "6D67FD").cgColor, offset: CGSize(width: 0, height: 3), opacity: 0.8, radius: 5)
        inConta_view.addShadow(view: inConta_view, color: UIColor.lightGray.cgColor, offset: CGSize(width: 0, height: 3), opacity: 0.4, radius: 5)
        signInBtn.addShadow(view: signInBtn, color: UIColor.hexStringToUIColor(hex: "6D67FD").cgColor, offset: CGSize(width: 0, height: 3), opacity: 0.8, radius: 5)
        
        //
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
    }
    
    func checkTextFields() -> Bool {
        
        if img_view.image == nil {
            self.showAlert(title: "EF", message: "Picture is required.")
            return false
        }
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
    
    func noCamera(){
        let alertController = UIAlertController(title: "eBookBazaar", message: "Sorry this device has no camera.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "We need location access.",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - CLLocationManagerDelegate
extension EFSignUpVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            currLoc = location
            print(location.coordinate)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error :\(error)")
    }
}

// MARK: - ImagePicker Delegates
extension EFSignUpVC: UIImagePickerControllerDelegate {
        
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
            var tempImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
   
            let imgData: NSData = NSData(data: (tempImage).jpegData(compressionQuality: 1)!)
            let imageSize: Int = imgData.length
            let size = imageSize/(1024*1024)
            print("Image Size: %f KB", imageSize/(1024*1024))
            if(size > 3) {
                tempImage  = self.resizeImage(image: tempImage, targetSize: CGSize(width: 150, height: 150))
            }else{ }
        
            img_view.image = tempImage
        
            self.dismiss(animated: true, completion: nil)
               
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
}


