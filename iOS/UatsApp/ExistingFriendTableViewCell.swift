//
//  ExistingFriendTableViewCell.swift
//  UatsApp
//
//  Created by Student on 19/10/15.
//  Copyright © 2015 Paul Paul. All rights reserved.
//

import UIKit

class ExistingFriendTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var contactData: ContactData! {
        didSet {
            self.textLabel?.text = contactData.email
            self.accessoryType = contactData.checked ? .Checkmark : .None
        }
    }
}
