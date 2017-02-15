//
//  MedicardAccountsTableViewCell.swift
//  Medicard
//
//  Created by Al John Albuera on 9/28/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit

class MedicardAccountsTableViewCell: UITableViewCell {
    
    
    @IBOutlet var lblMemberName: UILabel!
    @IBOutlet var lblMemberCardNumber: UILabel!
    @IBOutlet var imgMemberQRCode: UIImageView!
    @IBOutlet var btnVerification: UIButton!
    @IBOutlet var btnDeleteAccount: UIButton!
    @IBOutlet var vAccounts: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
