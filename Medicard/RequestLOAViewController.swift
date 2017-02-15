//
//  RequestLOAViewController.swift
//  Medicard
//
//  Created by Al John Albuera on 10/11/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit

class RequestLOAViewController: UIViewController {
    
    @IBOutlet var revealButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "LOA Requests"
        
        if revealViewController() != nil {
            
            //revealViewController().rightViewRevealWidth = 150
            revealButton.target = revealViewController()
            revealButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
