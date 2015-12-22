//
//  HomeTableViewCell.swift
//  beacons_test
//
//  Created by Rob Block on 12/11/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: - Outlets & Actions
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var preferedOrderLabel: UILabel!
    @IBOutlet weak var preferedOptionsLabel: UILabel!
    @IBOutlet weak var distanceToMerchantLabel: UILabel!
    @IBOutlet weak var distanceImageView: UIImageView!
}
