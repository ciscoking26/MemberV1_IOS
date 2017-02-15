//
//  GenerateQRCode.swift
//  Medicard
//
//  Created by Al John Albuera on 10/11/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit
import Foundation

class GenerateQRCode: NSObject {
    
    class func generateQR(qrImageView: UIImageView, memberID: String){
        
        var qrcodeImage: CIImage!
        
        if qrcodeImage == nil {
            
            
            let data = memberID.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter!.setValue(data, forKey: "inputMessage")
            filter!.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter!.outputImage
            
            
            let scaleX = qrImageView.frame.size.width / qrcodeImage.extent.size.width
            let scaleY = qrImageView.frame.size.height / qrcodeImage.extent.size.height
            
            let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
            
           qrImageView.image = UIImage(ciImage: transformedImage)
            
            
        }
        else {
            qrImageView.image = nil
            qrcodeImage = nil
        }

    }
    
    

}
