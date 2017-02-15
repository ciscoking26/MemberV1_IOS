//
//  RegisterViewController.swift
//  Medicard
//
//  Created by Al John Albuera on 9/27/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SCLAlertView
import Alamofire
import SwiftyJSON
import ReachabilitySwift



class RegisterViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    
    @IBOutlet var registrerScrollView: UIScrollView!
    @IBOutlet var registerView: UIView!
    @IBOutlet var btnRegisterAccount: UIButton!
    @IBOutlet var edtUsername: UITextField!
    @IBOutlet var edtPassword: UITextField!
    @IBOutlet var edtRetypePass: UITextField!
    @IBOutlet var edtContactNumber: UITextField!
    @IBOutlet var edtMedicardName: UITextField!
    @IBOutlet var edtMedicardNum: UITextField!
    @IBOutlet var edtDateOfBirth: UITextField!
    @IBOutlet var btnVerifyAccount: UIButton!
    @IBOutlet var edtEmailAddress: UITextField!
    @IBOutlet var registerContainerAlertView: UIView!
    @IBOutlet var registerContentAlertView: UIView!
    @IBOutlet var termsScroll: UIScrollView!
    @IBOutlet var termsView: UIView!
    
    let validateForm = FormValidation()
    let reachability = Reachability()
    let datePickerView  : UIDatePicker = UIDatePicker()
    var closeIndicator: Int!
    var dateNumber: String!
    var gender: String!
    var memFName: String!
    var memLName: String!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Registration"
        
        
        //Button Modification
        btnRegisterAccount.layer.cornerRadius = 2
        btnVerifyAccount.layer.cornerRadius = 2
        
        var image = UIImage(named: "ic_close_white@2x.png")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelRegistration(_:)))
        
        registrerScrollView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
        termsScroll.contentInset = UIEdgeInsetsMake(0, 0, termsView.frame.size.height / 1.8, 0);
        
        
        print("UDID: " + (GUIDString() as String))
        
        
        if reachability?.isReachable != true{
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.noInternetConnectionMessage, closeButtonTitle:"OK")
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        edtUsername.resignFirstResponder()
        edtPassword.resignFirstResponder()
        edtRetypePass.resignFirstResponder()
        edtDateOfBirth.resignFirstResponder()
        edtMedicardNum.resignFirstResponder()
        edtMedicardName.resignFirstResponder()
        edtContactNumber.resignFirstResponder()
        edtEmailAddress.resignFirstResponder()
        
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField == edtUsername) {
            ShowKeyboard.animateViewMoving(up: true, moveValue: -100, view: self.view)
        }else if(textField == edtPassword){
            ShowKeyboard.animateViewMoving(up: true, moveValue: -100, view: self.view)
        }else if (textField == edtRetypePass){
            ShowKeyboard.animateViewMoving(up: true, moveValue: -100, view: self.view)
        }else if (textField == edtContactNumber){
            ShowKeyboard.animateViewMoving(up: true, moveValue: -100, view: self.view)
        }else if (textField == edtEmailAddress){
            ShowKeyboard.animateViewMoving(up: true, moveValue: -100, view: self.view)
        }
        if(textField == edtDateOfBirth){
            addDatePicker()
        }
        if(textField == edtMedicardNum){
            addToolBarMedicarNum()
        }
        if(textField == edtContactNumber){
            addToolBarContactNum()
        }
        
        
        btnVerifyAccount.isEnabled = false
        btnVerifyAccount.isUserInteractionEnabled = false
        btnVerifyAccount.backgroundColor = UIColor(red:201/255.0, green:202/255.0, blue:204/255.0, alpha: 1.0)
        
        
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField == edtUsername) {
            ShowKeyboard.animateViewMoving(up: false, moveValue: -100, view: self.view)
        }else if(textField == edtPassword){
            ShowKeyboard.animateViewMoving(up: false, moveValue: -100, view: self.view)
        }else if (textField == edtRetypePass){
            ShowKeyboard.animateViewMoving(up: false, moveValue: -100, view: self.view)
        }else if (textField == edtContactNumber){
            ShowKeyboard.animateViewMoving(up: false, moveValue: -100, view: self.view)
        }else if (textField == edtEmailAddress){
            ShowKeyboard.animateViewMoving(up: false, moveValue: -100, view: self.view)
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == edtContactNumber{
            
            let maxLength = 11
            let currentString: NSString = edtContactNumber.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= maxLength
            
        }else if textField == edtMedicardNum{
            
            let maxLength = 8
            let currentString: NSString = edtMedicardNum.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= maxLength
            
        }else if textField == edtUsername{
            
            
            let maxLength = 13
            let currentString: NSString = edtUsername.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= maxLength
            
            
            
        }
        
        return true
    }
    
    
    func cancelRegistration(_ sender: AnyObject){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func registerAccount(_ sender: AnyObject) {
        
        if (validateForm.isEmpty(edtUsername) || validateForm.isEmpty(edtPassword) || validateForm.isEmpty(edtRetypePass) || validateForm.isEmpty(edtDateOfBirth) || validateForm.isEmpty(edtMedicardNum) || validateForm.isEmpty(edtMedicardName) || validateForm.isEmpty(edtEmailAddress)) {
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.errorEmptyFields, closeButtonTitle:"OK")
            
        }else if(validateForm.isContainUpperCase(edtPassword) == false && validateForm.isContainNumber(edtPassword) == false){
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningPasswordValidation, closeButtonTitle:"OK")
            
        }else if validateForm.isContainUpperCase(edtPassword) == true && validateForm.isContainNumber(edtPassword) == false{
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningPasswordValidation, closeButtonTitle:"OK")
            
            
        }else if validateForm.isContainUpperCase(edtPassword) == false && validateForm.isContainNumber(edtPassword) == true{
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningPasswordValidation, closeButtonTitle:"OK")
            
            
        }else if (edtPassword.text?.characters.count)! < 8{
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningPasswordMinimum, closeButtonTitle:"OK")
            
        }else if(edtUsername.text?.contains(" "))!{
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningInvalidUsername, closeButtonTitle:"OK")
            
        }else if (edtUsername.text?.characters.count)! < 3{
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningCharacterMinimum, closeButtonTitle:"OK")
            
        }else{
            
            if(edtPassword.text != edtRetypePass.text){
                
                _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningPasswordDidntMatch, closeButtonTitle:"OK")
                
            }else{
                
                if(edtPassword.text?.contains(" "))!{
                    
                    _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningPasswordValidation, closeButtonTitle:"OK")
                    
                }else{
                    
                    if (validateForm.isValidEmail(edtEmailAddress)){
                        
                        showAlertView()
                        
                    }else{
                        
                        _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningInvalidEmail, closeButtonTitle:"OK")
                    }
                    
                }
                
            }
            
            
        }
        
        
        
        
    }
    
    @IBAction func termsAndConditions(_ sender: AnyObject) {
        
        
        let goToTermsAndCondition = self.storyboard!.instantiateViewController(withIdentifier: "TermAndConditionViewController") as! TermAndConditionViewController
        self.navigationController?.pushViewController(goToTermsAndCondition, animated: true)
        
    }
    
    @IBAction func agreeTerms(_ sender: AnyObject) {
        
        closeIndicator = 0
        closeAlertView()
        
    }
    
    
    @IBAction func disagreeTerms(_ sender: AnyObject) {
        
        closeIndicator = 1
        closeAlertView()
        
    }
    
    
    @IBAction func verifyAccount(_ sender: AnyObject) {
        
        if validateForm.isEmpty(edtMedicardNum) || validateForm.isEmpty(edtDateOfBirth){
            
            _ = SCLAlertView().addButton("Okay") {
                print("Second button tapped")
            }
            
            _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.errorEmptyFields, closeButtonTitle:"OK")
            
        }else{
            
            if reachability?.isReachable == true{
                
                let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.indeterminate
                loadingNotification.label.text = "Verifying..."
                loadingNotification.isUserInteractionEnabled = false;
                
                
                verifyMember()
                
            }else{
                
                _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.noInternetConnectionMessage, closeButtonTitle:"OK")
                
            }
            
            
            
        }
        
    }
    
    
    
    func addDatePicker(){
        
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        edtDateOfBirth.inputView = datePickerView
        datePickerView.backgroundColor = UIColor.white
        datePickerView.maximumDate = Date()
        datePickerView.addTarget(self, action: #selector(self.datePickerHandler(sender:)), for: UIControlEvents.valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.backgroundColor = UIColor.darkGray
        toolBar.sizeToFit()
        
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(70), height: CGFloat(35))
        btn.setBackgroundImage(UIImage(named: "bar_button_bg@2x.png")!, for: .normal)
        btn.addTarget(self, action: #selector(self.datePickerDoneClick), for: .touchUpInside)
        let Item = UIBarButtonItem(customView: btn)
        self.toolbarItems = [Item]
        
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, Item], animated: false)
        toolBar.isUserInteractionEnabled = true
        edtDateOfBirth.inputAccessoryView = toolBar
    }
    
    
    func addToolBarMedicarNum(){
        
        let toolBar = UIToolbar()
        toolBar.backgroundColor = UIColor.darkGray
        toolBar.sizeToFit()
        
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(70), height: CGFloat(35))
        btn.setBackgroundImage(UIImage(named: "bar_button_bg@2x.png")!, for: .normal)
        btn.addTarget(self, action: #selector(self.pickerDoneClicked), for: .touchUpInside)
        let Item = UIBarButtonItem(customView: btn)
        self.toolbarItems = [Item]
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, Item], animated: false)
        toolBar.isUserInteractionEnabled = true
        edtMedicardNum.inputAccessoryView = toolBar
        
        
    }
    
    
    func addToolBarContactNum(){
        
        let toolBar = UIToolbar()
        toolBar.backgroundColor = UIColor.darkGray
        toolBar.sizeToFit()
        
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(70), height: CGFloat(35))
        btn.setBackgroundImage(UIImage(named: "bar_button_bg@2x.png")!, for: .normal)
        btn.addTarget(self, action: #selector(self.pickerDoneClicked), for: .touchUpInside)
        let Item = UIBarButtonItem(customView: btn)
        self.toolbarItems = [Item]
        
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, Item], animated: false)
        toolBar.isUserInteractionEnabled = true
        edtContactNumber.inputAccessoryView = toolBar
        
        
    }
    
    func pickerDoneClicked(){
        
        if validateForm.isEmpty(edtMedicardNum) || validateForm.isEmpty(edtDateOfBirth){
            
            btnVerifyAccount.isEnabled = false
            btnVerifyAccount.isUserInteractionEnabled = false
            btnVerifyAccount.backgroundColor = UIColor(red:201/255.0, green:202/255.0, blue:204/255.0, alpha: 1.0)
            
        }else{
            
            
            btnVerifyAccount.isEnabled = true
            btnVerifyAccount.isUserInteractionEnabled = true
            btnVerifyAccount.backgroundColor = UIColor(red:163/255.0, green:83/255.0, blue:153/255.0, alpha: 1.0)
            
            
        }
        
        edtDateOfBirth.resignFirstResponder()
        edtMedicardNum.resignFirstResponder()
        edtContactNumber.resignFirstResponder()
        
        
    }
    
    func datePickerDoneClick(){
        
        edtDateOfBirth.resignFirstResponder()
        
        let dateFormatterCompleteDate = DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatterCompleteDate.dateFormat = "MMMM dd, YYYY"
        edtDateOfBirth.text = dateFormatterCompleteDate.string(from: datePickerView.date)
        dateNumber = dateFormatter.string(from: datePickerView.date)
        
        btnVerifyAccount.isEnabled = true
        btnVerifyAccount.isUserInteractionEnabled = true
        btnVerifyAccount.backgroundColor = UIColor(red:163/255.0, green:83/255.0, blue:153/255.0, alpha: 1.0)
        
    }
    
    func datePickerHandler(sender: UIDatePicker) {
        let dateFormatterCompleteDate = DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatterCompleteDate.dateFormat = "MMMM dd, YYYY"
        edtDateOfBirth.text = dateFormatterCompleteDate.string(from: sender.date)
        dateNumber = dateFormatter.string(from: datePickerView.date)
    }
    
    
    func changeTextFieldColor(){
        
        //Background Color
        edtUsername.backgroundColor = UIColor.clear
        edtPassword.backgroundColor = UIColor.clear
        edtRetypePass.backgroundColor = UIColor.clear
        edtContactNumber.backgroundColor = UIColor.clear
        edtEmailAddress.backgroundColor = UIColor.clear
        btnRegisterAccount.backgroundColor = UIColor(red:163/255.0, green:83/255.0, blue:153/255.0, alpha: 1.0)
        
        //Set Enabled
        edtUsername.isEnabled = true
        edtPassword.isEnabled = true
        edtRetypePass.isEnabled = true
        edtContactNumber.isEnabled = true
        edtEmailAddress.isEnabled = true
        btnRegisterAccount.isEnabled = true
        
        //Set Interaction
        edtUsername.isUserInteractionEnabled = true
        edtPassword.isUserInteractionEnabled = true
        edtRetypePass.isUserInteractionEnabled = true
        edtContactNumber.isUserInteractionEnabled = true
        edtEmailAddress.isUserInteractionEnabled = true
        btnRegisterAccount.isUserInteractionEnabled = true
        
        
        
    }
    
    
    
    func changeTextFieldColorDisable(){
        
        //Background Color
        edtUsername.backgroundColor = UIColor(red:250/255.0, green:250/255.0, blue:250/255.0, alpha: 1.0)
        edtPassword.backgroundColor = UIColor(red:250/255.0, green:250/255.0, blue:250/255.0, alpha: 1.0)
        edtRetypePass.backgroundColor = UIColor(red:250/255.0, green:250/255.0, blue:250/255.0, alpha: 1.0)
        edtContactNumber.backgroundColor = UIColor(red:250/255.0, green:250/255.0, blue:250/255.0, alpha: 1.0)
        edtEmailAddress.backgroundColor = UIColor(red:250/255.0, green:250/255.0, blue:250/255.0, alpha: 1.0)
        btnRegisterAccount.backgroundColor = UIColor(red:201/255.0, green:202/255.0, blue:204/255.0, alpha: 1.0)
        
        //Set Enabled
        edtUsername.isEnabled = false
        edtPassword.isEnabled = false
        edtRetypePass.isEnabled = false
        edtContactNumber.isEnabled = false
        edtEmailAddress.isEnabled = false
        btnRegisterAccount.isEnabled = false
        
        //Set Interaction
        edtUsername.isUserInteractionEnabled = false
        edtPassword.isUserInteractionEnabled = false
        edtRetypePass.isUserInteractionEnabled = false
        edtContactNumber.isUserInteractionEnabled = false
        edtEmailAddress.isUserInteractionEnabled = false
        btnRegisterAccount.isUserInteractionEnabled = false
        
    }
    
    
    func showAlertView(){
        
        registerContentAlertView
            .transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.registerContentAlertView.transform = .identity
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
            
        })
        
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.2
        registerContainerAlertView.layer.add(animation, forKey: nil)
        registerContentAlertView.layer.add(animation, forKey: nil)
        registerContainerAlertView.isHidden = false
        registerContentAlertView.isHidden = false
        
    }
    
    
    func closeAlertView(){
        
        
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.2
        registerContainerAlertView.layer.add(animation, forKey: nil)
        registerContentAlertView.layer.add(animation, forKey: nil)
        registerContainerAlertView.isHidden = true
        registerContentAlertView.isHidden = true
        
        
        if closeIndicator == 0 {
            
            if reachability?.isReachable == true{
                
                let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.indeterminate
                loadingNotification.label.text = "Creating Account..."
                loadingNotification.isUserInteractionEnabled = false;
                
                registerPost()
                
                
            }else{
                
                _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.noInternetConnectionMessage, closeButtonTitle:"OK")
                
            }
            
            
            
        }
        
    }
    
    
    func GUIDString() -> NSString {
        let newUniqueID = CFUUIDCreate(kCFAllocatorDefault)
        let newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
        let guid = newUniqueIDString as! NSString
        
        return guid.lowercased as NSString
    }
    
    
    func registerPost() {
        
        let medicardIDNumber = edtMedicardNum.text! as String
        let medicardDateOfBirth = edtDateOfBirth.text! as String
        let medicardPassword = edtPassword.text! as String
        let medicardPhoneNumber = edtContactNumber.text! as String
        let medicardEmailAdd = edtEmailAddress.text! as String
        let medicardRegisterDevice = (GUIDString() as String)
        let medicardMemberUsername = edtUsername.text! as String
        
        
        let registrationPost = ["username": medicardMemberUsername, "password": medicardPassword, "memberCode": medicardIDNumber, "memBday": medicardDateOfBirth, "memFname": memFName, "memLname": memLName, "memMi": "", "phone": medicardPhoneNumber, "email": medicardEmailAdd, "registerDevice": medicardRegisterDevice, "memSex": gender] as [String : Any]
        
        print(registrationPost)
        
        Alamofire.request(PostRouter.postRegistration(registrationPost as [String : AnyObject]))
            .responseJSON { response in
                if response.result.isFailure == true {
                    
                    
                    print("ERROR", response.description)
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningMemberAccountAlreadyExist, closeButtonTitle:"OK")
                    
                }
                
                
                if let value: AnyObject = response.result.value as AnyObject? {
                    
                    let post = JSON(value)
                    print("JSON: " + post.description)
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    _ = SCLAlertView().showSuccess(AlertMessages.successTitle, subTitle:AlertMessages.successAccountCreated, closeButtonTitle:"OK")
                    
                    self.edtUsername.text = ""
                    self.edtMedicardNum.text = ""
                    self.edtDateOfBirth.text = ""
                    self.edtMedicardName.text = ""
                    self.edtPassword.text = ""
                    self.edtRetypePass.text = ""
                    self.edtContactNumber.text = ""
                    self.edtEmailAddress.text = ""
                    
                    self.changeTextFieldColorDisable()
                    
                    self.btnVerifyAccount.isEnabled = false
                    self.btnVerifyAccount.isUserInteractionEnabled = false
                    self.btnVerifyAccount.backgroundColor = UIColor(red:201/255.0, green:202/255.0, blue:204/255.0, alpha: 1.0)
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    
                }
                
        }
    }
    
    func verifyMember(){
        
        let memberCardNumber =  edtMedicardNum.text!
        let newDateOfBirth = dateNumber.replacingOccurrences(of: "-", with: "")
        
        print("DOB: " + newDateOfBirth)
        print("MEMBER ID: " + memberCardNumber)
        
        let verifyParams = ["memberCode": memberCardNumber, "dob": newDateOfBirth]
        
        let request = Alamofire.request(PostRouter.getVerifyMember(verifyParams as [String: AnyObject]))
            .responseJSON { response in
                guard response.result.error == nil else {
                    print(response.result.error!)
                    
                    return
                }
                
                if let value: AnyObject = response.result.value as AnyObject? {
                    let post = JSON(value)
                    let memberInfo = post["MemberInfo"]
                    
                    
                    if post["responseCode"].stringValue == "230"{
                        
                        _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningMemberAccountAlreadyExist, closeButtonTitle:"OK")
                        
                    }else if post["responseCode"].stringValue == "210"{
                        
                        _ = SCLAlertView().showWarning(AlertMessages.errorTitle, subTitle:AlertMessages.warningMemberAccountDoesntMatch, closeButtonTitle:"OK")
                        
                    }else{
                        
                        if memberInfo["Mem_OStat_Code"].description == "ACTIVE"{
                            
                            let fullname = memberInfo["MEM_NAME"].description
                            self.edtMedicardName.text = fullname
                            self.memFName = memberInfo["MEM_FNAME"].description
                            self.memLName = memberInfo["MEM_LNAME"].description
                            self.btnVerifyAccount.isEnabled = false
                            self.btnVerifyAccount.backgroundColor = UIColor(red:201/255.0, green:202/255.0, blue:204/255.0, alpha: 1.0)
                            self.btnVerifyAccount.isUserInteractionEnabled = false
                            self.changeTextFieldColor()
                            
                            if memberInfo["MEM_SEX"].description == "1"{
                                self.gender = "F"
                            }else{
                                self.gender = "M"
                            }
                            
                        }else{
                            
                            
                            self.edtMedicardName.text = ""
                            self.changeTextFieldColorDisable()
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                }
        }
        debugPrint(request)
        
    }
    
}
