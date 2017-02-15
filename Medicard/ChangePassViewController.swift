//
//  ChangePassViewController.swift
//  Medicard
//
//  Created by Al John Albuera on 11/23/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit
import SCLAlertView
import Alamofire
import SwiftyJSON

class ChangePassViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var revealButton: UIBarButtonItem!
    @IBOutlet var edtUsername: UITextField!
    @IBOutlet var edtOldPassword: UITextField!
    @IBOutlet var edtNewPassword: UITextField!
    @IBOutlet var btnChangePassword: UIButton!
    @IBOutlet var edtRetypePassword: UITextField!
    
    var forceChangePassword: String!
    
    var forceChangePass: String!
     let defaults = UserDefaults.standard
    
    
     let validateForm = FormValidation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        forceChangePass = defaults.value(forKey: "forceChangePassword") as! String!
        print("FORCE CHANGE PASS: " + forceChangePass!)

         let memberCode = defaults.string(forKey: "storedUsername")! as String
        
        btnChangePassword.layer.cornerRadius = 2
        edtUsername.text = memberCode
        edtUsername.becomeFirstResponder()
        
        if revealViewController() != nil {
            
            //revealViewController().rightViewRevealWidth = 150
            revealButton.target = revealViewController()
            revealButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

            let tapPressGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            revealButton.customView?.addGestureRecognizer(tapPressGesture)

        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if forceChangePass != nil{
            
            if forceChangePass == "1" {
                
                self.title = "Change Password"
                self.navigationItem.rightBarButtonItem?.image = nil;
                
                _ = SCLAlertView().showWarning("Hold On", subTitle:"You need to change your password.", closeButtonTitle:"OK")
                
                var image = UIImage(named: "ic_close_white@2x.png")
                image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBackToLogin))
                edtUsername.isEnabled = false
                edtUsername.isUserInteractionEnabled = false

                
                
            }else{
                
                self.title = "Account Settings"
                self.navigationItem.leftBarButtonItem?.isEnabled = false;
                self.navigationItem.leftBarButtonItem?.image = nil;
                
            }
            
        }

    }
    
    
    func dismissKeyboard(){
        
        
        print("OPEN!")
        
    }
    
    func closeChangePassword(){
        
        self.dismiss(animated: true, completion: nil);
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        edtUsername.resignFirstResponder()
        edtNewPassword.resignFirstResponder()
        edtOldPassword.resignFirstResponder()
        edtRetypePassword.resignFirstResponder()
        
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        
        if textField == edtRetypePassword{
            
             ShowKeyboard.animateViewMoving(up: true, moveValue: -100, view: self.view)
            
        }
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        if textField == edtRetypePassword{
            
            ShowKeyboard.animateViewMoving(up: false, moveValue: -100, view: self.view)
            
        }
        edtUsername.resignFirstResponder()
        edtNewPassword.resignFirstResponder()
        edtOldPassword.resignFirstResponder()
        edtRetypePassword.resignFirstResponder()
    }
    
    
    
    
    
    @IBAction func changePassword(_ sender: Any) {
        
        if edtUsername.text == "" || edtOldPassword.text == "" || edtNewPassword.text == ""{
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.errorEmptyFields, closeButtonTitle:"OK")
            
        }else if(validateForm.isContainUpperCase(edtNewPassword) == false && validateForm.isContainNumber(edtNewPassword) == false){
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningPasswordValidation, closeButtonTitle:"OK")
            
        }else if validateForm.isContainUpperCase(edtNewPassword) == true && validateForm.isContainNumber(edtNewPassword) == false{
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningPasswordValidation, closeButtonTitle:"OK")
            
            
        }else if validateForm.isContainUpperCase(edtNewPassword) == false && validateForm.isContainNumber(edtNewPassword) == true{
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningPasswordValidation, closeButtonTitle:"OK")
            
            
        }else if edtNewPassword.text != edtRetypePassword.text{
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningPasswordRetypePassDidntMatch, closeButtonTitle:"OK")
            
        }else{
                
                if(edtNewPassword.text != edtRetypePassword.text){
                    
                    _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningPasswordDidntMatch, closeButtonTitle:"OK")
                    
                }else{
                    
                    if(edtNewPassword.text?.contains(" "))!{
                        
                        _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningPasswordValidation, closeButtonTitle:"OK")
                        
                    }else{
                        
                            
                            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                            loadingNotification.mode = MBProgressHUDMode.indeterminate
                            loadingNotification.label.text = "Requesting..."
                            loadingNotification.isUserInteractionEnabled = false;
                            
                            changeYourPassword(username: edtUsername.text!, newPassword: edtNewPassword.text!, oldPassword: edtOldPassword.text!)
                        
                        
                    }
                    
                }

        }
        
    }
    
    
    func changeYourPassword(username: String, newPassword: String, oldPassword: String){
        
        let changePassword = ["username": username, "newPassword": newPassword, "oldPassword": oldPassword] as [String : Any]
        
        print("CHANGE PASSWORD DATA:\(changePassword)")
        
        Alamofire.request(PostRouter.postChangePassword(changePassword as [String : AnyObject]))
            .responseJSON { response in
                if response.result.isFailure == true {
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.errorChangePassword, closeButtonTitle:"OK")
                    
                }
                
                if let value: AnyObject = response.result.value as AnyObject? {
                    
                    let post = JSON(value)
                    
                    print("JSON DATA ADD ACCOUNT: " + post.description)
                    
                    
                    if post["responseCode"].stringValue == "200"{
                        
                        if self.forceChangePass != nil{
                            
                            if self.forceChangePass == "1" {
                                
                                self.edtOldPassword.text = ""
                                self.edtNewPassword.text = ""
                                self.edtRetypePassword.text = ""
                                self.edtUsername.becomeFirstResponder()
                                
                                self.defaults.set("0", forKey: "forceChangePassword")
                                
                                _ = SCLAlertView().showSuccess(AlertMessages.successTitle, subTitle:AlertMessages.sucessChangePassword, closeButtonTitle:"OK")
                                
                                self.dismiss(animated: true, completion: nil)
                                
                            }else{
                                
                                self.edtOldPassword.text = ""
                                self.edtNewPassword.text = ""
                                self.edtRetypePassword.text = ""
                                self.edtUsername.becomeFirstResponder()
                                
                                self.defaults.set("0", forKey: "forceChangePassword")
                                self.defaults.set(self.edtUsername.text, forKey: "storedUsername")
                                self.defaults.set(self.edtNewPassword.text, forKey: "storedPassword")
                                
                                _ = SCLAlertView().showSuccess(AlertMessages.successTitle, subTitle:AlertMessages.sucessChangePassword, closeButtonTitle:"OK")
                                
                            }
                            
                        }

                        
                    }else if post["responseCode"].stringValue == "230"{
                        
                        _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningInvalidUsernamePassword, closeButtonTitle:"OK")
                        
                    }
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                }else{
                    
                    _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.errorChangePassword, closeButtonTitle:"OK")
                    
                }
                
        }
        
    }
    
    
    
    func goBackToLogin(){
        
        let defaults = UserDefaults.standard
        defaults.set("0", forKey: "loginStatus")
        defaults.set("", forKey: "username")
        defaults.set("", forKey: "password")
        defaults.set("", forKey: "storedUsername")
        defaults.set("", forKey: "storedPassword")
        
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated:true, completion: nil)
        
    }
    

}
