//
//  ViewQRCodeViewController.swift
//  Medicard
//
//  Created by Al John Albuera on 10/13/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit
import ReachabilitySwift
import SCLAlertView

class ViewQRCodeViewController: UIViewController {
    
    @IBOutlet var lblMemberNane: UILabel!
    @IBOutlet var lblMemberCode: UILabel!
    @IBOutlet var imgQRCode: UIImageView!
    
    
    var memberCode: String!
    var memberName: String!
    var memberBday: String!
    
    let reachability = Reachability()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "QR Code"
        
        
        lblMemberNane.text = memberName
        lblMemberCode.text = memberCode
        GenerateQRCode.generateQR(qrImageView: imgQRCode, memberID: memberCode)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
