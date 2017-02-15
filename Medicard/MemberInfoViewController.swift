//
//  MemberInfoViewController.swift
//  Medicard
//
//  Created by Al John Albuera on 10/9/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit
import KCFloatingActionButton
import Alamofire
import SwiftyJSON
import ReachabilitySwift
import SCLAlertView

class MemberInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet var tblMemberInformation: UITableView!
    @IBOutlet var revealButton: UIBarButtonItem!
    
    
    var showingBack = true
    
    var passmemberName: String!
    var passmemberType: String!
    var passmemberCode: String!
    var passmemberCompany: String!
    var passmemberFname: String!
    var passmemberLname: String!
    var passmemBday: String!
    var passmemAge: String!
    var passmemCivilStat: String!
    var passmemGender: String!
    var passmemAccountStat: String!
    var passmemCode: String!
    var passmemPlanDesc: String!
    var passmemEffectiveDate: String!
    var passmemValidityDate: String!
    var passmemDDLimit: String!
    var passmemPhoto: UIImage!
    var passmemType: String!
    var passmemRem1: String!
    var passmemRem2: String!
    var passmemRem3: String!
    var passmemRem4: String!
    var passmemRem5: String!
    var passmemRem6: String!
    var passmemRem7: String!
    var forceChangePass: String!
    
    
    
    //DEPENDENTS
    var depmemberName = [String] ()
    var depmemberFName = [String] ()
    var depmemberLName = [String] ()
    var depmemberCode = [String] ()
    
    let defaults = UserDefaults.standard
    

    let reachability = Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.title = "My Account"
        
        let fab = KCFloatingActionButton()
        fab.buttonColor = UIColor(red:163/255.0, green:83/255.0, blue:153/255.0, alpha: 1.0)
        fab.plusColor = UIColor.white
        fab.overlayColor = UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 0.6)
        fab.addItem("Register Dependent", icon: UIImage(named: "ic_person_add_white@3x.png"), handler: {_ in
        
            
            self.showAddAccountAlert()
            
        
        })
        self.view.addSubview(fab)
        
        
        if revealViewController() != nil {
            
            revealButton.target = revealViewController()
            revealButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        }
        
        
        forceChangePass = defaults.value(forKey: "forceChangePassword") as! String!
        print("FORCE CHANGE PASS: " + forceChangePass!)
        
        
        if forceChangePass != nil{
            
            if forceChangePass == "1" {
                let changePassword = self.storyboard!.instantiateViewController(withIdentifier: "ChangePassViewController") as! ChangePassViewController
                let navBar = UINavigationController(rootViewController: changePassword)
                self.navigationController?.present(navBar, animated:true, completion: nil)
            }
            
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        depmemberFName.removeAll()
        depmemberLName.removeAll()
        depmemberCode.removeAll()
        
        
        if reachability?.isReachable == true{
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Loading..."
            loadingNotification.isUserInteractionEnabled = false;
            
            getMemberInformation()
            
        }else{
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.noInternetConnectionMessage, closeButtonTitle:"OK")
            
            tblMemberInformation.isHidden = true
            
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0){
            return 1
        }else{
            return self.depmemberCode.count
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        if(indexPath.section == 0){

            let cell:MemberInfoTableViewCell! = tblMemberInformation.dequeueReusableCell(withIdentifier: "memberInfo", for: indexPath) as! MemberInfoTableViewCell
            
            cell.imgProfilePic.layer.cornerRadius = 62
            cell.imgProfilePic.layer.borderWidth = 3.0
            cell.imgProfilePic.layer.borderColor = UIColor(red:241/255.0, green:242/255.0, blue:242/255.0, alpha: 1.0).cgColor
            cell.imgProfilePic.clipsToBounds = true

            
            
            cell.principalName.text = passmemberName 
            cell.principalStatus.text = passmemberType
            cell.principalMemCode.text = passmemberCode
            cell.principalCompany.text = passmemberCompany
            
        
            
            if cell.imgProfilePic.image != nil{
                cell.aiLoadPhoto.startAnimating()
            }else{
                
                cell.imgProfilePic.image = UIImage(named:"photo_placeholder.jpg")
                cell.aiLoadPhoto.startAnimating()
                cell.aiLoadPhoto.isHidden = false
            }
            

            cell.selectionStyle = .none
            
                
            return cell
                
        }else{

            let cell:DependentsTableViewCell! = tblMemberInformation.dequeueReusableCell(withIdentifier: "dependents", for: indexPath) as! DependentsTableViewCell
            
            
            cell.dependentName.text = self.depmemberFName[indexPath.row] + " " + self.depmemberLName[indexPath.row]
            cell.dependentMemID.text = self.depmemberCode[indexPath.row]
            cell.dependentCompany.text = passmemberCompany
            
            

            cell.selectionStyle = .none
            
            return cell
            
        }
        

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            
            if indexPath.row == 0{
                
                let goToMemberInfo = self.storyboard!.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
                goToMemberInfo.name = passmemberFname + " " + passmemberLname
                goToMemberInfo.memCode = passmemberCode
                navigationController?.pushViewController(goToMemberInfo, animated: true)
                
            }
            
        }else{
            
            let goToMemberInfo = self.storyboard!.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
            goToMemberInfo.name = self.depmemberFName[indexPath.row] + " " + self.depmemberLName[indexPath.row]
            goToMemberInfo.memCode = self.depmemberCode[indexPath.row]
            navigationController?.pushViewController(goToMemberInfo, animated: true)
            
        
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        if indexPath.section == 0 {
            return 280
        }else{
            return 200
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30.0
        }
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }

    
    
    func getMemberInformation(){
        
        let defaults = UserDefaults.standard
        let memberCode = defaults.string(forKey: "memberCode")! as String
        
        
        let request = Alamofire.request(PostRouter.getMemberInformation(memberCode))
            .responseJSON { response in
                guard response.result.error == nil else {
                    print(response.result.error!)
                    
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    return
                }
                
                if let value: AnyObject = response.result.value as AnyObject? {
                    let post = JSON(value)
                    let memberInfo = post["MemberInfo"]
                    
                    print("JSON DATA" + memberInfo.description)

                    
                    self.passmemberName = memberInfo["MEM_NAME"].description 
                    self.passmemberType = memberInfo["MEM_TYPE"].description
                    self.passmemberCode = memberInfo["PRIN_CODE"].description
                    self.passmemberCompany = memberInfo["ACCOUNT_NAME"].description
                    self.passmemberFname = memberInfo["MEM_FNAME"].description
                    self.passmemberLname = memberInfo["MEM_LNAME"].description
                    
                    
                    let defaults = UserDefaults.standard
                    defaults.set(self.passmemberFname + " " + self.passmemberLname, forKey: "memberFullname")
                    
                    
                    
                    for item in post["Dependents"].arrayValue{
                        
                       
                        let dependentFName = item["memFname"].stringValue
                        let dependentLName = item["memLname"].stringValue
                        let dependentCode = item["memCode"].stringValue
                    
                        self.depmemberFName.append(dependentFName)
                        self.depmemberLName.append(dependentLName)
                        self.depmemberCode.append(dependentCode)
                        
                        
                    }

                    
                    DispatchQueue.main.async {
                        self.tblMemberInformation.reloadData()
                        self.dowloadPhoto()
                        
                    }
                
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                }
        }
        debugPrint(request)

    }
    
    
    func dowloadPhoto()  {
        
        let defaults = UserDefaults.standard
        let memberCode = defaults.string(forKey: "memberCode")

        let indexPath = IndexPath(row: 0, section: 0)
        let cell:MemberInfoTableViewCell! = tblMemberInformation.dequeueReusableCell(withIdentifier: "memberInfo", for: indexPath) as! MemberInfoTableViewCell
        
        
        cell.aiLoadPhoto.startAnimating()
        cell.aiLoadPhoto.isHidden = false
        cell.imgProfilePic.image = UIImage(named:"photo_placeholder.jpg")
        let imageData = UIImageJPEGRepresentation(cell.imgProfilePic.image!, 0.5)
        self.passmemPhoto = UIImage(data:imageData! as Data)


        UserDefaults.standard.set("0", forKey: "photoStatus")
        
        
        
        Alamofire.request(defaults.value(forKey: "link1") as! String! + "downloadpicture/" + memberCode!).responseImage { response in
            debugPrint(response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                
                let imageData = UIImageJPEGRepresentation(image, 0.5)
                self.passmemPhoto = UIImage(data:imageData! as Data)
                cell.imgProfilePic.image = UIImage(data:imageData! as Data)
                
                
                cell.aiLoadPhoto.stopAnimating()
                cell.aiLoadPhoto.isHidden = true
                
                UserDefaults.standard.set(imageData, forKey: "profilePhoto")
                UserDefaults.standard.set("1", forKey: "photoStatus")

                
            }else{
                
                print("ERROR")
                cell.aiLoadPhoto.stopAnimating()
                cell.aiLoadPhoto.isHidden = true

                
            }
        }
    }
    
    func showAddAccountAlert(){
        
        let defaults = UserDefaults.standard
        let memberCode = defaults.string(forKey: "memberCode")
        let memberUsername = defaults.string(forKey: "storedUsername");
        
        let alert = SCLAlertView()
        let username = alert.addTextField(memberUsername)
        let depMemAccountNum = alert.addTextField("Dependent Member ID")
        alert.addButton("REGISTER ACCOUNT") {
            
            if username.text == "" || depMemAccountNum.text == ""{
                
                self.showAddAccountAlert()
                
                 _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningInputMemberID, closeButtonTitle:"OK")
                
                
            }else{
                
                let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.indeterminate
                loadingNotification.label.text = "Adding member..."
                loadingNotification.isUserInteractionEnabled = false;
                
                self.postAddMemberAccount(memUsername: username.text!, depAccountNum: depMemAccountNum.text!, memberCode: memberCode!)
            }
            
          
           
        }
        alert.showEdit("Register Dependent", subTitle: "")
        
    }
    
    
    
    func postAddMemberAccount(memUsername: String, depAccountNum: String, memberCode: String){
        
        let addAccountPost = ["username": memUsername, "depMemberCode": depAccountNum, "memberCode": memberCode] as [String : Any]
        
        Alamofire.request(PostRouter.postAddDependents(addAccountPost as [String : AnyObject]))
            .responseJSON { response in
                if response.result.isFailure == true {
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                }
                
                if let value: AnyObject = response.result.value as AnyObject? {
                    
                    let post = JSON(value)
                    
                    print("JSON RETURN: \(post.description)")
                    
                    if post["responseCode"].stringValue == "230"{
                        
                        self.showAddAccountAlert()
                        
                        _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.errorAlreadAdded, closeButtonTitle:"OK")
                        
                        self.depmemberFName.removeAll()
                        self.depmemberLName.removeAll()
                        self.depmemberCode.removeAll()
                        self.getMemberInformation()
                        
                    }else if post["responseCode"].stringValue == "231"{
                        
                        self.showAddAccountAlert()
                        
                        _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.errorNotADependent, closeButtonTitle:"OK")
                        
                        self.depmemberFName.removeAll()
                        self.depmemberLName.removeAll()
                        self.depmemberCode.removeAll()
                        self.getMemberInformation()
                        
                    }else{
                        
                         _ = SCLAlertView().showSuccess(AlertMessages.successTitle, subTitle:AlertMessages.successAddDependent, closeButtonTitle:"OK")
                        
                        self.depmemberFName.removeAll()
                        self.depmemberLName.removeAll()
                        self.depmemberCode.removeAll()
                        self.getMemberInformation()
                        
                    }

                     MBProgressHUD.hide(for: self.view, animated: true)
                    
                }else{
                    
                    _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.errorNotADependent, closeButtonTitle:"OK")
                    
                }
                
        }
        
    }
    
}
