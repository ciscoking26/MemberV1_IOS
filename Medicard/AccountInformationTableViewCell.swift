//
//  AccountInformationTableViewCell.swift
//  Medicard
//
//  Created by Al John Albuera on 10/13/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit

class AccountInformationTableViewCell: UITableViewCell {
    
    @IBOutlet var accountInfo: UIView!
    @IBOutlet var lblAccountStatus: UILabel!
    @IBOutlet var lblMemberCode: UILabel!
    @IBOutlet var lblMemberType: UILabel!
    @IBOutlet var lblEffectivityDate: UILabel!
    @IBOutlet var lblValidityDate: UILabel!
    @IBOutlet var lblDDLimit: UILabel!
    @IBOutlet var lblRemarks: UILabel!
    @IBOutlet var lblPlanDesc: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
