//
//  CellToShowDetailsTableViewCell.swift
//  SignUpWithRestAPI
//
//  Created by appinventiv on 14/09/17.
//  Copyright © 2017 yogesh singh negi. All rights reserved.
//

import UIKit

class CellToShowDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
