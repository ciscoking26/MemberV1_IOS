//
//  MemberInfoTableViewCell.swift
//  Medicard
//
//  Created by Al John Albuera on 10/9/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit

class MemberInfoTableViewCell: UITableViewCell {
    
    
    @IBOutlet var viewPrincipal: UIView!
    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var principalName: UILabel!
    @IBOutlet var principalStatus: UILabel!
    @IBOutlet var principalMemCode: UILabel!
    @IBOutlet var principalCompany: UILabel!
    @IBOutlet var aiLoadPhoto: UIActivityIndicatorView!
    @IBOutlet var lblCompany: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
