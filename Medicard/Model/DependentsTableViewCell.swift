//
//  DependentsTableViewCell.swift
//  Medicard
//
//  Created by Al John Albuera on 10/13/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit

class DependentsTableViewCell: UITableViewCell {
    
    
    @IBOutlet var viewDependents: UIView!
    @IBOutlet var dependentName: UILabel!
    @IBOutlet var dependentCompany: UILabel!
    @IBOutlet var dependentMemID: UILabel!
    @IBOutlet var dependentRelation: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
