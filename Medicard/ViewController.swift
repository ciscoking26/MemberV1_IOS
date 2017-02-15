//
//  ViewController.swift
//  Medicard
//
//  Created by Al John Albuera on 9/26/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView
import CRToastSwift
import SCLAlertView
import Alamofire
import SwiftyJSON
import ReachabilitySwift


class ViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable{
    
    
    
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    let validateForm = FormValidation()
    let reachability = Reachability()
    let pingUrl = PingUrl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.isHidden = true
        
        btnSignIn.layer.cornerRadius = 2
        btnSignUp.layer.cornerRadius = 2
        btnSignUp.layer.borderWidth = 1
        btnSignUp.layer.borderColor = UIColor(red:163/255.0, green:83/255.0, blue:153/255.0, alpha: 1.0).cgColor
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        txtUsername.resignFirstResponder()
        txtPassword.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func signUpButton(_ sender: AnyObject) {
        
        
        self.txtUsername.text = ""
        self.txtPassword.text = ""
        
        let goToRegistration = self.storyboard!.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        let navController = UINavigationController(rootViewController: goToRegistration)
        self.present(navController, animated:true, completion: nil)
            

    }
    
    
    @IBAction func signInButton(_ sender: AnyObject) {
        
        
        if (validateForm.isEmpty(txtUsername) || validateForm.isEmpty(txtPassword)) {
    
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.errorEmptyFields, closeButtonTitle:"OK")
            
            
        }else{
            
            if reachability?.isReachable == true{
                
                let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.indeterminate
                loadingNotification.label.text = "Logging in..."
                loadingNotification.isUserInteractionEnabled = false;
                
                login()
                
            }else{
                
                _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.noInternetConnectionMessage, closeButtonTitle:"OK")
            }
            
        }
       
    }
    

    
    func login(){
        
        let username = txtUsername.text! as String
        let password = txtPassword.text! as String
        
        let loginPost = ["username": username, "password": password] as [String : Any]
       
        Alamofire.request(PostRouter.postLogin(loginPost as [String : AnyObject]))
            .responseJSON { response in
                if response.result.isFailure == true {
                    
                    print("ERROR", response.description)
                    
                }
                
                if let value: AnyObject = response.result.value as AnyObject? {
                    
                    let post = JSON(value)
                    
                    
                    print("JSON DATA:\(post.description)")
                    
                    if post["responseCode"].stringValue == "210"{
                        
                        _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.errorNoUserAccount, closeButtonTitle:"OK")
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                    }else if post["responseCode"].stringValue == "220"{
                        
                         _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.errorAccountLocked, closeButtonTitle:"OK")
   
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                         print("JSON DATA 220")
                        
                    }else if post["responseCode"].stringValue == "230"{
                        
                         MBProgressHUD.hide(for: self.view, animated: true)
                        
                        _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.errorCredentials, closeButtonTitle:"OK")
                        
                    }else{
                        
                        let userData = post["UserAccount"]
                        
                        print("JSON DATA" + userData.description)
                        
                        let defaults = UserDefaults.standard
                        defaults.set("1", forKey: "loginStatus")
                        defaults.set(userData["MEM_CODE"].description, forKey: "memberCode")
                        defaults.set(self.txtUsername.text, forKey: "username")
                        defaults.set(self.txtPassword.text, forKey: "password")
                        defaults.set(self.txtUsername.text, forKey: "storedUsername")
                        defaults.set(self.txtPassword.text, forKey: "storedPassword")
                        defaults.set(userData["FORCE_CHANGE_PASSWORD"].description, forKey: "forceChangePassword")
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        self.txtUsername.text = ""
                        self.txtPassword.text = ""
                        
                        
                        let medicardAccounts = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        medicardAccounts.modalTransitionStyle = .crossDissolve
                        self.present(medicardAccounts, animated:true, completion: nil)

                        
                    }
                    
                }
                
            }
        
        }
    
    
}

