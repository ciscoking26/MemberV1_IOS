//
//  TermAndConditionViewController.swift
//  Medicard
//
//  Created by Al John Albuera on 10/11/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit

class TermAndConditionViewController: UIViewController {
    
    
    @IBOutlet var termsAndConditionScroll: UIScrollView!
    @IBOutlet var termsAndConditionView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Terms and Conditions"
        
         termsAndConditionScroll.contentInset = UIEdgeInsetsMake(0, 0, termsAndConditionView.frame.size.height / 3.8, 0);

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
