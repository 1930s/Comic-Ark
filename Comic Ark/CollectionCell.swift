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
            
            if let comicTitle = comic.title {
                titleLabel.text = comicTitle
            }
            
            if let comicAuthors = comic.authors {
                authorsLabel.text?.removeAll()
                
                for (index, author) in comicAuthors.enumerated() {
                    if index != comicAuthors.count - 1 {
                        authorsLabel.text?.append(author + ", ")
                    } else {
                        authorsLabel.text?.append(author)
                    }
                }
            }
           
            if let comicPublisher = comic.publisher {
                publisherLabel.text = comicPublisher
            }
            
            if let comicCoverURL = comic.coverURL {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: comicCoverURL) {
                        DispatchQueue.main.async {
                            self.coverView.image = UIImage(data: data)
                        }
                    }
                }    
            }
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
