//
//  PreferedTableViewCell.swift
//  beacons_test
//
//  Created by Rob Block on 12/15/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit

class PreferedTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var item_nameLabel: UILabel!
    @IBOutlet weak var item_OptionsLabel: UILabel!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var merchantAddressLabel: UILabel!
}
