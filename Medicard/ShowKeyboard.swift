//
//  ShowKeyboard.swift
//  Medicard
//
//  Created by Al John Albuera on 9/28/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit
import Foundation

class ShowKeyboard: NSObject {
    
    class func animateViewMoving (up:Bool, moveValue :CGFloat, view: UIView){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? moveValue : -moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        view.frame = view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
}
