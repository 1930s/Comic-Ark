//
//  CollectionCell.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 07..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import UIKit

class CollectionCell: UITableViewCell {
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    
    var comic: Comic! {
        didSet {
            
            titleLabel.text = comic.title
            
            authorsLabel.text?.removeAll()
                
            for (index, author) in comic.authors.enumerated() {
                if index != comic.authors.count - 1 {
                    authorsLabel.text?.append(author + ", ")
                } else {
                    authorsLabel.text?.append(author)
                    }
                }
            
           
            if let comicPublisher = comic.publisher {
                publisherLabel.text = comicPublisher
            }
            
//            if let comicCover = comic.coverImage {
//                coverView.image = comicCover
//            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
