//
//  PingUrl.swift
//  Medicard
//
//  Created by Al John Albuera on 1/10/17.
//  Copyright © 2017 Al John Albuera. All rights reserved.
//

import UIKit

class PingUrl: NSObject {
    
    
    var linkStatus : Bool = false
    
    func isConnectedToNetwork() -> Bool {
    
        let url = NSURL(string: "http://mace-public00.medicardphils.com:8080/memberloa/emailTester/")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        let session = URLSession.shared
        
        
        session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            print("data \(data)")
            print("response \(response)")
            print("error \(error)")
            
            if let httpResponse = response as? HTTPURLResponse {
                print("httpResponse.statusCode \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                   
                    self.linkStatus = true
                    
                }
            }
            
        }).resume()
        
        
        return linkStatus
        
    }

}
