//
//  MyAccountViewController.swift
//  Medicard
//
//  Created by Al John Albuera on 10/11/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit
import KCFloatingActionButton
import Alamofire
import SCLAlertView
import SwiftyJSON
import AlamofireImage
import ReachabilitySwift


class MyAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var tblAccountInformation: UITableView!
    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var mainScroll: UIScrollView!
    @IBOutlet var btnShowQRCode: UIButton!
    @IBOutlet var memberName: UILabel!
    @IBOutlet var memberID: UILabel!
    @IBOutlet var aiLoadPhoto: UIActivityIndicatorView!
    
    let imagePicker = UIImagePickerController()
    let imageResize = ImageResizer()
    let reachability = Reachability()
    
    
    
    //PassedValues
    var name: String!
    var memCompany: String!
    var memCode: String!
    var dialogIndicator: Int!
    var height: CGFloat!
    var memRemarks: String!
    var bday: String!
    
    
    //NEW VAR
    var dependentMemberName: String!
    var dependentMemberType: String!
    var dependentMemberCode: String!
    var dependentMemberCompany: String!
    var dependentMemberFname: String!
    var dependentMemberLname: String!
    var dependentMemBday: String!
    var dependentMemAge: String!
    var dependentMemCivilStat: String!
    var dependentMemGender: String!
    var dependentMemAccountStat: String!
    var dependentMemCode: String!
    var dependentMemPlanDesc: String!
    var dependentMemEffectiveDate: String!
    var dependentMemValidityDate: String!
    var dependentMemDDLimit: String!
    var dependentMemPhoto: UIImage!
    var dependentMemType: String!
    var dependentMemRem1: String!
    var dependentMemRem2: String!
    var dependentMemRem3: String!
    var dependentMemRem4: String!
    var dependentMemRem5: String!
    var dependentMemRem6: String!
    var dependentMemRem7: String!
    
    let defaults = UserDefaults.standard

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        self.title = "Member Information"
        
        
        var height: CGFloat = 250
        height *= 2
        
        
        var tableFrame = tblAccountInformation.frame
        tableFrame.size.height = height
        tableFrame.size.width = self.view.frame.size.width - 47
        tableFrame.origin.x = 20
        tableFrame.origin.y = 300
        tblAccountInformation.frame = tableFrame
        
        var viewFrame = viewContainer.frame
        viewFrame.size.height = height + tblAccountInformation.frame.size.height / 3
        viewFrame.size.width = self.view.frame.size.width
        viewFrame.origin.y  = 300;
        viewContainer.frame = viewFrame
        
        viewContainer.translatesAutoresizingMaskIntoConstraints = true;
        

        
        imgProfilePic.layer.cornerRadius = 62
        imgProfilePic.layer.borderWidth = 3.0
        imgProfilePic.layer.borderColor = UIColor(red:241/255.0, green:242/255.0, blue:242/255.0, alpha: 1.0).cgColor
        imgProfilePic.image = UIImage(named:"photo_placeholder.jog")
        imgProfilePic.clipsToBounds = true
        
        mainScroll.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
        
        btnShowQRCode.layer.cornerRadius = 2

//        //Floating Action Bar
//        let fab = KCFloatingActionButton()
//        fab.buttonColor = UIColor(red:163/255.0, green:83/255.0, blue:153/255.0, alpha: 1.0)
//        fab.plusColor = UIColor.white
//        fab.overlayColor = UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 0.6)
//        fab.addItem("Request LOA", icon: UIImage(named: "ic_print_white@3x.png"))
//        self.view.addSubview(fab)
        
        imagePicker.delegate = self

        
        memberID.text = memCode
        memberName.text = name
        
        
        UserDefaults.standard.set("0", forKey: "photoStatus")
        
        
        if reachability?.isReachable != true{
            
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.noInternetConnectionMessage, closeButtonTitle:"OK")
            
            tblAccountInformation.isHidden = true
            mainScroll.isScrollEnabled = false
            
        }
        
        
        imgProfilePic.image = UIImage(named:"photo_placeholder.jpg")
        
        //fetch dependentInformation
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        loadingNotification.isUserInteractionEnabled = false;
        getDependentInformation(memberID: memCode)

    
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            
            return 1
            
        }else if section == 1{
            
            return 1
            
        }else {
            
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.section == 0) {
            
             let cell:MemInformationTableViewCell! = tblAccountInformation.dequeueReusableCell(withIdentifier: "memInformation", for: indexPath) as! MemInformationTableViewCell
            
            
            cell.lblBirthdate.text = dependentMemBday
            cell.lblAge.text = dependentMemAge
            cell.lblCivilStatus.text = dependentMemCivilStat
            
            
            if dependentMemGender != nil{
                
                if dependentMemGender == "0" {
                    cell.lblGender.text = "FEMALE"
                }else{
                    cell.lblGender.text = "MALE"
                }

            }
            
            cell.lblCompany.text = dependentMemberCompany
            cell.selectionStyle = .none
            
            return cell
            
        }else if(indexPath.section == 1){
            
             let cell:AccountInformationTableViewCell! = tblAccountInformation.dequeueReusableCell(withIdentifier: "accountInformation", for: indexPath) as! AccountInformationTableViewCell
            
            
            if dependentMemAccountStat != nil {
                
                if (dependentMemAccountStat == "ACTIVE") {
                    
                    cell.lblAccountStatus.text = "ACTIVE"
                    
                }else if (dependentMemAccountStat == "DISAPPROVED") {
                    
                    cell.lblAccountStatus.text = "DISAPPROVED"
                    
                }else if (dependentMemAccountStat == "FOR ENCODING") {
                    
                    cell.lblAccountStatus.text = "PENDING"
                    
                }else if (dependentMemAccountStat == "MEDICAL EVALUATION") {
                    
                    cell.lblAccountStatus.text = "PENDING"
                    
                }else if (dependentMemAccountStat == "ON HOLD") {
                    
                    cell.lblAccountStatus.text = "PENDING"
                    
                }else if (dependentMemAccountStat == "FOR APPROVAL") {
                    
                    cell.lblAccountStatus.text = "PENDING"
                    
                }else if (dependentMemAccountStat == "RESIGNED") {
                    
                    cell.lblAccountStatus.text = "INACTIVE"
                    
                }else if (dependentMemAccountStat == "CANCELLED") {
                    
                    cell.lblAccountStatus.text = "INACTIVE"
                    
                }else if (dependentMemAccountStat == "PENDING (E-MEDICARD)") {
                    
                    cell.lblAccountStatus.text = "PENDING"
                    
                }else if (dependentMemAccountStat == "LAPSE (NON RENEW)") {
                    
                    cell.lblAccountStatus.text = "INACTIVE"
                    
                }else if (dependentMemAccountStat == "FOR REACTIVATION") {
                    
                    cell.lblAccountStatus.text = "INACTIVE"
                    
                }else if (dependentMemAccountStat == "VERIFY PAYMENT WITH RMD") {
                    
                    cell.lblAccountStatus.text = "PENDING"
                    
                }else if (dependentMemAccountStat == "VERIFY RENEWAL FROM MARKETING / SALES") {
                    
                    cell.lblAccountStatus.text = "PENDING"
                    
                }else if (dependentMemAccountStat == "VERIFY MEMBERSHIP") {
                    
                    cell.lblAccountStatus.text = "PENDING"
                    
                }
                
            }
            
            
            cell.lblMemberCode.text = dependentMemberCode
            cell.lblMemberType.text = dependentMemberType
            cell.lblEffectivityDate.text = dependentMemEffectiveDate
            cell.lblValidityDate.text = dependentMemValidityDate
            
            
            if dependentMemRem1 != nil || dependentMemRem2 != nil || dependentMemRem3 != nil || dependentMemRem4 != nil || dependentMemRem5 != nil || dependentMemRem6 != nil || dependentMemRem7 != nil{
                
                
                memRemarks = dependentMemRem1 + "\n" + dependentMemRem2 + "\n" + dependentMemRem3 + "\n" + dependentMemRem4 + "\n" + dependentMemRem5 + "\n" + dependentMemRem6 + "\n" + dependentMemRem7
                
                let newMemRem = memRemarks.replacingOccurrences(of: "\nnull", with: " ")
                let newFinalRem = newMemRem.replacingOccurrences(of: "null", with: " ")
                let newTrimmedChar = newFinalRem.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)
                
                cell.lblRemarks.text = newTrimmedChar

                
            }

            cell.lblPlanDesc.text = dependentMemType
            cell.lblMemberType.sizeToFit()
            cell.selectionStyle = .none
            
            
            return cell
            
        }else{
            
            let cell = tblAccountInformation.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            return cell
        }

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 240
        }else{
            return self.tblAccountInformation.frame.size.height
        }
        
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10.0
        }
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    

    @IBAction func showQRCode(_ sender: AnyObject) {
        
            
            let sampleBday = dependentMemBday + " 00:00:00 +0000"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss Z"
            let memFormatBday = dateFormatter.date(from: sampleBday)
            dateFormatter.dateFormat = "YYYYMMdd"
            let memFormatBday2 = dateFormatter.string(from: memFormatBday!)
            
            
            
            let showQRCode = self.storyboard!.instantiateViewController(withIdentifier: "ViewQRCodeViewController") as! ViewQRCodeViewController
            showQRCode.memberCode = dependentMemberCode
            showQRCode.memberName = dependentMemberName
            showQRCode.memberBday = memFormatBday2
            self.navigationController?.pushViewController(showQRCode, animated: true)

    }
    
    
    
    @IBAction func choosePhoto(_ sender: AnyObject) {
        
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.chooseFromCamera()
            self.dialogIndicator = 0
        })
        let saveAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.dialogIndicator = 0
            self.chooseFromGallery()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in

            
        })
        
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    
    func chooseFromGallery(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    func chooseFromCamera(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }

        
    }

    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imgProfilePic.image = image
            
        } else{
            print("Something went wrong")
        }
    
        self.dismiss(animated: true, completion: nil)
        
        
        self.showAlertView(header: AlertMessages.uploadPhotoTitle, message: AlertMessages.warningUploadPhoto)
        
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func showAlertView(header: String, message: String){
        
        let alertController = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelButton = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            
            self.dowloadPhoto()
            
        }
        let okButton = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
                
                if self.reachability?.isReachable == true{
                    
                    let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                    loadingNotification.mode = MBProgressHUDMode.indeterminate
                    loadingNotification.label.text = "Uploading Photo..."
                    loadingNotification.isUserInteractionEnabled = false;
                    
                    self.uploadPhoto()
                    
                }else{
                    
                    _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.noInternetConnectionMessage, closeButtonTitle:"OK")
                    
                }
            
        }
        alertController.addAction(cancelButton)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func getDependentInformation(memberID: String){
        
        
        let request = Alamofire.request(PostRouter.getMemberInfo(memberID))
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
                    
                    
                    self.dependentMemberName = memberInfo["MEM_NAME"].description
                    self.dependentMemberType = memberInfo["MEM_TYPE"].description
                    self.dependentMemberCode = memberInfo["PRIN_CODE"].description
                    self.dependentMemberCompany = memberInfo["ACCOUNT_NAME"].description
                    self.dependentMemberFname = memberInfo["MEM_FNAME"].description
                    self.dependentMemberLname = memberInfo["MEM_LNAME"].description
                    self.dependentMemBday = memberInfo["BDAY"].description
                    self.dependentMemAge = memberInfo["AGE"].description
                    self.dependentMemCivilStat = memberInfo["CIVIL_STATUS"].description
                    self.dependentMemGender = memberInfo["MEM_SEX"].description
                    self.dependentMemberCompany = memberInfo["ACCOUNT_NAME"].description
                    self.dependentMemAccountStat = memberInfo["Mem_OStat_Code"].description
                    self.dependentMemPlanDesc = memberInfo["MEM_TYPE"].description
                    self.dependentMemEffectiveDate = memberInfo["EFF_DATE"].description
                    self.dependentMemValidityDate = memberInfo["VAL_DATE"].description
                    self.dependentMemDDLimit = memberInfo["DD_Reg_Limits"].description
                    self.dependentMemType = memberInfo["Plan_Desc"].description
                    self.dependentMemRem1 = memberInfo["ID_REM"].description
                    self.dependentMemRem2 = memberInfo["ID_REM2"].description
                    self.dependentMemRem3 = memberInfo["ID_REM3"].description
                    self.dependentMemRem4 = memberInfo["ID_REM4"].description
                    self.dependentMemRem5 = memberInfo["ID_REM5"].description
                    self.dependentMemRem6 = memberInfo["ID_REM6"].description
                    self.dependentMemRem7 = memberInfo["ID_REM7"].description
                    
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    DispatchQueue.main.async {
                        self.tblAccountInformation.reloadData()
                        
                        self.aiLoadPhoto.startAnimating()
                        self.aiLoadPhoto.isHidden = false
                        self.dowloadPhoto()
                        
                    }
                    
                    
                }
        }
        debugPrint(request)

    }

    func uploadPhoto(){
        
        if dependentMemberCode != nil{
        
            let params = ["memCode": dependentMemberCode!]
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(UIImageJPEGRepresentation(self.imageResize.resizeImage(image: self.imgProfilePic.image!, targetSize: CGSize(width: 150, height: 150)), 0.5)!, withName: "file", fileName: "picture.jpg", mimeType: "image/jpeg")
                    
                    for (key, value) in params {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                    
            },
                to:defaults.value(forKey: "link1") as! String! + "uploadpicture",
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                            
                            print("STATUS: \(response.response?.statusCode)")
                            
                            _ = SCLAlertView().showSuccess(AlertMessages.successTitle, subTitle:AlertMessages.successUploadPhoto, closeButtonTitle:"OK")
                            
                            UserDefaults.standard.set("1", forKey: "uploadPhotoStatus")
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.errorUploadPhoto, closeButtonTitle:"OK")
                        
                    }
            })
        }
    }
    
    
    func dowloadPhoto()  {
        
        if dependentMemberCode != nil{
            
            Alamofire.request(defaults.value(forKey: "link1") as! String! + "downloadpicture/" + dependentMemberCode).responseImage { response in
                debugPrint(response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    
                    self.aiLoadPhoto.stopAnimating()
                    self.aiLoadPhoto.isHidden = true
                    self.imgProfilePic.image = UIImage(named:"photo_placeholder.jpg")
                    
                    let imageData = UIImagePNGRepresentation(image)
                    self.imgProfilePic.image = UIImage(data:imageData! as Data)
                    
                    
                }else{
                    
                    self.aiLoadPhoto.stopAnimating()
                    self.aiLoadPhoto.isHidden = true
                    self.imgProfilePic.image = UIImage(named:"photo_placeholder.jpg")
                    
                }
            }

            
        }
        
        
    }
    
}
