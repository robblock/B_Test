//
//  HomeFavoritesTableViewCell.swift
//  beacons_test
//
//  Created by Rob Block on 12/22/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit

class HomeFavoritesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var preferedOrderLabel: UILabel!
    @IBOutlet weak var preferedOptionsLabel: UILabel!
    @IBOutlet weak var merchantLocationLabel: UILabel!
}
