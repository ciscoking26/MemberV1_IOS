
//
//  SideMenuViewController.swift
//  Medicard
//
//  Created by Al John Albuera on 10/11/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit
import SCLAlertView
import Alamofire

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tblSideMenu: UITableView!
    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var btnLogout: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblSideMenu.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tblSideMenu.sizeToFit()
        tblSideMenu.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var CellIdentifier = "Cell"
        
        switch indexPath.row {
        case 0:
            CellIdentifier = "myAccount"
        case 1:
            CellIdentifier = "accountSettings"
        case 2:
            CellIdentifier = "logout"
       
            
        default: break
            
        }
        
         let cell = tblSideMenu.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2{
            
            let alert = SCLAlertView()
            _ = alert.addButton("YES"){
                
                let defaults = UserDefaults.standard
                defaults.set("0", forKey: "loginStatus")
                defaults.set("", forKey: "username")
                defaults.set("", forKey: "password")
                defaults.set("", forKey: "storedUsername")
                defaults.set("", forKey: "storedPassword")
                
                let goToMainView = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                goToMainView.modalTransitionStyle = .crossDissolve
                self.present(goToMainView, animated:true, completion: nil)
                
            }
            
            let icon = UIImage(named:"ic_white_logout.png")
            //#231F20
            let color = UIColor(red:35/255.0, green:31/255.0, blue:32/255.0, alpha: 1.0)
            
            _ = alert.showCustom("Hold On", subTitle: "Are you sure you want to logout?", color: color, icon: icon!)
            
            
        }
        
    }
}
