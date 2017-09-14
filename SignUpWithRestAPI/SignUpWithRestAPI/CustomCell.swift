//
//  CustomCell.swift
//  SignUpWithRestAPI
//
//  Created by appinventiv on 13/09/17.
//  Copyright © 2017 yogesh singh negi. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell{

    @IBOutlet weak var userDetailsTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
