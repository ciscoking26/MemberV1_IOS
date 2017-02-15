//
//  ShowSnackBar.swift
//  Medicard
//
//  Created by Al John Albuera on 10/6/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit
import CRToast
import CRToastSwift




class ShowSnackBar: NSObject {
    
    class func snackBar(message:String){
        
        let notification = CRToastSwift.NotificationController(title: message)
        notification.backgroundColor = UIColor(red:163/255.0, green:83/255.0, blue:153/255.0, alpha: 1.0)
        notification.present()

        
    }


}
