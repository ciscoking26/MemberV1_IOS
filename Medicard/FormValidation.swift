//
//  FormValidation.swift
//  Medicard
//
//  Created by Al John Albuera on 10/6/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit

class FormValidation: NSObject {
    
    
    func isEmpty(_ field: UITextField) -> Bool {
        if (field.text == "") {
            return true
        }
        return false
    }
    
    
    func isValidEmail(_ field: UITextField) -> Bool {
        let emailValue = field.text
        let regex = "[^@]+@[A-Za-z0-9.-]+\\.[A-Za-z]+"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if emailPredicate.evaluate(with: emailValue) {
            return true
        }
        return false
    }
    
    
    func isContainUpperCase(_ field: UITextField) -> Bool {
        
        //.*[A-Z0-9]+.*
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: field.text)
        if texttest.evaluate(with: capitalLetterRegEx) {
            
            print(capitalresult)
            
            return capitalresult
        }

        return capitalresult
    }

    
    func isContainNumber(_ field: UITextField) -> Bool {
        
        //.*[A-Z0-9]+.*
        
        let numericRegEx  = ".*[0-9]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", numericRegEx)
        let numericresult = texttest.evaluate(with: field.text)
        if texttest.evaluate(with: numericRegEx) {
            
            print(numericresult)
            
            return numericresult
        }
        
        return numericresult
    }

    

}
