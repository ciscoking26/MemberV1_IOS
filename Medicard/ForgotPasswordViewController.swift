//
//  ForgotPasswordViewController.swift
//  Medicard
//
//  Created by Al John Albuera on 11/23/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView
import SwiftyJSON

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var barbtnClose: UIBarButtonItem!
    @IBOutlet var edtUsername: UITextField!
    @IBOutlet var edtMemberCode: UITextField!
    @IBOutlet var btnSendNewPass: UIButton!
    
    
    let validateForm = FormValidation()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Forgot Password"

        // Do any additional setup after loading the view.
        
        btnSendNewPass.layer.cornerRadius = 2
        edtUsername.becomeFirstResponder()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        edtUsername.resignFirstResponder()
        edtMemberCode.resignFirstResponder()
        
        return true
    }

    
    
    @IBAction func closeView(_ sender: Any) {
        
        edtUsername.resignFirstResponder()
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func sendNewPass(_ sender: Any) {
        
        if edtUsername.text == "" || edtMemberCode.text == ""{
            
              _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.errorEmptyFields, closeButtonTitle:"OK")
            
        }else{
            
            if validateForm.isValidEmail(edtUsername){
                
                let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.indeterminate
                loadingNotification.label.text = "Requesting..."
                loadingNotification.isUserInteractionEnabled = false;
                requestNewPass()

            }else{
                
                 _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningInvalidEmail, closeButtonTitle:"OK")
                
            }

        }

    }
    
    
    func requestNewPass(){
        
        let addAccountPost = ["email": edtUsername.text!, "memberCode": edtMemberCode.text!] as [String : Any]
        
        Alamofire.request(PostRouter.postRequestNewPass(addAccountPost as [String : AnyObject]))
            .responseJSON { response in
                if response.result.isFailure == true {
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                     _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.errorChangePassword, closeButtonTitle:"OK")
                    
                }
                
                if let value: AnyObject = response.result.value as AnyObject? {
                    
                    let post = JSON(value)
                    
                    print("JSON DATA ADD ACCOUNT: " + post.description)
                    
                    if post["responseCode"].stringValue == "200"{
                        
                        self.edtMemberCode.text = ""
                        
                        let alert = SCLAlertView()
                        _ = alert.addButton("OK"){
                            
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                        
                        let appearance = SCLAlertView.SCLAppearance(
                            showCloseButton: false
                        )
                        let alertView = SCLAlertView(appearance: appearance)
                        alertView.addButton("OK") {
                            self.dismiss(animated: true, completion: nil)
                        }
                        alertView.showSuccess(AlertMessages.successTitle, subTitle:AlertMessages.succesCheckEmailPassword)
                        

                    }else if post["responseCode"].stringValue == "230"{
                        
                        _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningInvalidMemberCodeAndUsername, closeButtonTitle:"OK")
                        
                    }
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                }
                
        }
        
        
    }

}
