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
    @IBOutlet weak var containerView: UIView!
    
    var publicProfile: PublicProfile? {
        didSet {
            guard let publicProfile = publicProfile else { return }
            usernameLabel.text = publicProfile.name
            comicCountLabel.text = publicProfile.bookCount == 1 ? "\(publicProfile.bookCount) comic" : "\(publicProfile.bookCount) comics"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 6.0
        containerView.clipsToBounds = true
    }
}
