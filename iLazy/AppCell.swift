//
//  AppCell.swift
//  iLazy
//
//  Created by East Agile on 4/13/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import UIKit

class AppCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setApp(obj: AppInfo){
        self.nameLabel.text = obj.name
        self.siteLabel.text = obj.site
        self.priceLabel.text = String(format: "%dC", obj.price)
    }
}
