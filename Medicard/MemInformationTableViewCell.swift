//
//  MemInformationTableViewCell.swift
//  Medicard
//
//  Created by Al John Albuera on 10/13/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit

class MemInformationTableViewCell: UITableViewCell {

    
    @IBOutlet var viewMemInfo: UIView!
    @IBOutlet var lblBirthdate: UILabel!
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var lblCivilStatus: UILabel!
    @IBOutlet var lblGender: UILabel!
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
