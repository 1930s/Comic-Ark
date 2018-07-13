//
//  CollectorCell.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 07. 07..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import UIKit

class CollectorCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var comicCountLabel: UILabel!
    
    var publicProfile: PublicProfile! {
        didSet {
            usernameLabel.text = publicProfile.name
            comicCountLabel.text = "\(publicProfile.bookCount) comics"
        }
    }
}
