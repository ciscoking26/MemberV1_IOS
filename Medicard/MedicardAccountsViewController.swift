//
//  MedicardAccountsViewController.swift
//  Medicard
//
//  Created by Al John Albuera on 9/28/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MedicardAccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    @IBOutlet var tblMedicardAccount: UITableView!
    @IBOutlet var btnAddAnAccount: UIButton!
    @IBOutlet var containerAlertView: UIView!
    @IBOutlet var contentAlertView: UIView!
    @IBOutlet var edtMedicardMemID: UITextField!
    @IBOutlet var edtMemBirthday: UITextField!
    @IBOutlet var edtMemberName: UITextField!
    @IBOutlet var btnAddAccount: UIButton!

    
    let datePickerView  : UIDatePicker = UIDatePicker()
    var qrData: [String] = ["111001617", "111001994", "111002016"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Accounts"
        
        
        contentAlertView.layer.cornerRadius = 5
        btnAddAnAccount.layer.cornerRadius = 2
        btnAddAccount.layer.cornerRadius = 2
        
        var image = UIImage(named: "ic_close_white@2x.png")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(closeAccount))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return qrData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:MedicardAccountsTableViewCell! = tblMedicardAccount.dequeueReusableCell(withIdentifier: "medicardAccounts", for: indexPath) as! MedicardAccountsTableViewCell
        
        //Add shadow
        cell.vAccounts.layer.shadowColor = UIColor.lightGray.cgColor
        cell.vAccounts.layer.shadowOpacity = 0.5
        cell.vAccounts.layer.shadowOffset = CGSize.zero
        cell.vAccounts.layer.shadowRadius = 3
        
        cell.btnVerification.layer.shadowColor = UIColor.lightGray.cgColor
        cell.btnVerification.layer.shadowOpacity = 0.5
        cell.btnVerification.layer.shadowOffset = CGSize.zero
        cell.btnVerification.layer.shadowRadius = 3
        
        
        GenerateQRCode.generateQR(qrImageView: cell.imgMemberQRCode, memberID: qrData[indexPath.row])
        
        
        cell!.selectionStyle = .none
        

        
        return cell!
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == edtMedicardMemID) {
            ShowKeyboard.animateViewMoving(up: true, moveValue: -100, view: self.view)
        }else if(textField == edtMemBirthday){
            ShowKeyboard.animateViewMoving(up: true, moveValue: -100, view: self.view)
        }else if(textField == edtMemberName){
            ShowKeyboard.animateViewMoving(up: true, moveValue: -100, view: self.view)
        }
        
        if(textField == edtMedicardMemID){
            addToolBarMedicarNum()
        }
        if(textField == edtMemBirthday){
            addDatePickers()
        }
        
    }
    
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        

        if(textField == edtMedicardMemID) {
            ShowKeyboard.animateViewMoving(up: false, moveValue: -100, view: self.view)
        }else if(textField == edtMemBirthday){
            ShowKeyboard.animateViewMoving(up: false, moveValue: -100, view: self.view)
        }else if(textField == edtMemberName){
            ShowKeyboard.animateViewMoving(up: false, moveValue: -100, view: self.view)
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        edtMemberName.resignFirstResponder()
        edtMemBirthday.resignFirstResponder()
        edtMedicardMemID.resignFirstResponder()
        
        
        return true
    }

    @IBAction func addAccount(_ sender: AnyObject){
        
        contentAlertView
            .transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.contentAlertView.transform = .identity
            }, completion: {(finished: Bool) -> Void in
                // do something once the animation finishes, put it here
        })

        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.2
        containerAlertView.layer.add(animation, forKey: nil)
        contentAlertView.layer.add(animation, forKey: nil)
        containerAlertView.isHidden = false
        contentAlertView.isHidden = false
        
        pickerDoneClicked()
        
    }

    @IBAction func registerMedicardAccount(_ sender: AnyObject) {
        

        
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.2
        containerAlertView.layer.add(animation, forKey: nil)
        contentAlertView.layer.add(animation, forKey: nil)
        containerAlertView.isHidden = true
        contentAlertView.isHidden = true
        
        edtMemberName.text = ""
        edtMemBirthday.text = ""
        edtMedicardMemID.text = ""
        
        pickerDoneClicked()
        
        
    }
    

    @IBAction func closeAlertView(_ sender: AnyObject) {
        
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.2
        containerAlertView.layer.add(animation, forKey: nil)
        contentAlertView.layer.add(animation, forKey: nil)
        containerAlertView.isHidden = true
        contentAlertView.isHidden = true
        
        edtMemberName.text = ""
        edtMemBirthday.text = ""
        edtMedicardMemID.text = ""
        
        pickerDoneClicked()
        
    }
    
    
    
    func addDatePickers(){
        

        datePickerView.datePickerMode = UIDatePickerMode.date
        edtMemBirthday.inputView = datePickerView
        datePickerView.backgroundColor = UIColor.white
        datePickerView.addTarget(self, action: #selector(self.datePickerHandler(sender:)), for: UIControlEvents.valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.backgroundColor = UIColor.darkGray
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.datePickerDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        edtMemBirthday.inputAccessoryView = toolBar
    }
    
    
    func addToolBarMedicarNum(){
        
        let toolBar = UIToolbar()
        toolBar.backgroundColor = UIColor.darkGray
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.pickerDoneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        edtMedicardMemID.inputAccessoryView = toolBar
        
        
    }
    
    
    func pickerDoneClicked(){
        
        edtMemBirthday.resignFirstResponder()
        edtMedicardMemID.resignFirstResponder()
        edtMemberName.resignFirstResponder()
        
    }
    
    func datePickerDoneClick(){
        
         edtMemBirthday.resignFirstResponder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        edtMemBirthday.text = dateFormatter.string(from: datePickerView.date)
        edtMemberName.text = "Al John Albuera"
        changeTextFieldStatus()
        
    }
    
    func datePickerHandler(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        edtMemBirthday.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    func changeTextFieldStatus(){
        
        //Set Enabled
        edtMedicardMemID.isEnabled = true
        edtMemBirthday.isEnabled = true
        edtMemberName.isEnabled = true
        
        //Set Interaction
        edtMedicardMemID.isUserInteractionEnabled = true
        edtMemBirthday.isUserInteractionEnabled = true
        edtMemberName.isUserInteractionEnabled = true
        
        
    }
    
    func closeAccount(){
        
        self.dismiss(animated: true, completion: nil)
        
        
    }

    
    
    
    
}
