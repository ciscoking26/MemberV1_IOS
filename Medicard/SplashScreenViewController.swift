//
//  SplashScreenViewController.swift
//  Medicard
//
//  Created by Al John Albuera on 11/23/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView
import SwiftyJSON
import ReachabilitySwift

class SplashScreenViewController: UIViewController {

    
    var storedUsername: String!
    var storePassword: String!
    let reachability = Reachability()
    
    @IBOutlet var aiLoadSplash: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        storedUsername = defaults.value(forKey: "storedUsername") as! String!
        storePassword = defaults.value(forKey: "storedPassword") as! String!
        
        aiLoadSplash.startAnimating()
        aiLoadSplash.isHidden = false
        
        
        
        let delayInSeconds = 3.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            
            if self.storedUsername == nil || self.storedUsername == "" || self.storePassword ==  nil || self.storePassword == ""{
                
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                viewController.modalTransitionStyle = .crossDissolve
                self.present(viewController, animated:true, completion: nil)
                
                self.aiLoadSplash.startAnimating()
                self.aiLoadSplash.isHidden = false
                
                
                
            }else{
                
                if self.reachability?.isReachable != true{
                    
                      _ = SCLAlertView().showWarning("No Internet Connection", subTitle:"Please try again and check your internet connection.", closeButtonTitle:"OK")
                    
                }else{
                    
                     self.login()
                    
                }
                
            }
            
        }
        
    }
    

    
    func login(){
        
        
        let loginPost = ["username": storedUsername, "password": storePassword] as [String : Any]
        
        Alamofire.request(PostRouter.postLogin(loginPost as [String : AnyObject]))
            .responseJSON { response in
                if response.result.isFailure == true {
                    
                    
                }
                
                if let value: AnyObject = response.result.value as AnyObject? {
                    
                    let post = JSON(value)
                    
                    if post["responseCode"] == "210" || post["responseCode"] == "230" || post["responseCode"] == "230"{
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        
                        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        viewController.modalTransitionStyle = .crossDissolve
                        self.present(viewController, animated:true, completion: nil)
                        
                        self.aiLoadSplash.startAnimating()
                        self.aiLoadSplash.isHidden = false

                        
                    }else{
                        
                        let userData = post["UserAccount"]
                        
                        print("JSON DATA" + userData.description)
                        
                        let defaults = UserDefaults.standard
                        defaults.set(userData["MEM_CODE"].description, forKey: "memberCode")
                         defaults.set(userData["FORCE_CHANGE_PASSWORD"].description, forKey: "forceChangePassword")
                        
                        self.aiLoadSplash.stopAnimating()
                        self.aiLoadSplash.isHidden = true
                        
                        
                        let medicardAccounts = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        medicardAccounts.modalTransitionStyle = .crossDissolve
                        self.present(medicardAccounts, animated:true, completion: nil)
                        
                        
                        
                    }
                    
                }
                
        }
        
    }
}
