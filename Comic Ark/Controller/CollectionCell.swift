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
    @IBOutlet var ratingButtons: [UIButton]!
    
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
            
            if comic.rating == 1 {
                ratingButtons[0].isSelected = true
            } else if comic.rating == 2 {
                ratingButtons[0].isSelected = true
                ratingButtons[1].isSelected = true
            } else if comic.rating == 3 {
                ratingButtons[0].isSelected = true
                ratingButtons[1].isSelected = true
                ratingButtons[2].isSelected = true
            } else {
                for button in ratingButtons {
                    button.isSelected = false
                }
            }
            
            if let comicCover = comic.coverImage {
                coverView.image = comicCover
            } else {
                coverView.image = #imageLiteral(resourceName: "no-image")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for button in ratingButtons {
            button.imageView?.contentMode = .scaleAspectFit
        }
    }

    @IBAction func ratingPressed(_ sender: UIButton) {
        
        if sender.tag == 1 {
            if sender.isSelected {
                sender.isSelected = false
                ratingButtons[1].isSelected = false
                ratingButtons[2].isSelected = false
                comic.rating = 0
            } else {
                sender.isSelected = true
                comic.rating = 1
            }
        } else if sender.tag == 2 {
            if sender.isSelected {
                sender.isSelected = false
                ratingButtons[0].isSelected = false
                ratingButtons[2].isSelected = false
                comic.rating = 0
            } else {
                sender.isSelected = true
                ratingButtons[0].isSelected = true
                comic.rating = 2
            }
        } else {
            if sender.isSelected {
                sender.isSelected = false
                ratingButtons[0].isSelected = false
                ratingButtons[1].isSelected = false
                comic.rating = 0
            } else {
                sender.isSelected = true
                ratingButtons[0].isSelected = true
                ratingButtons[1].isSelected = true
                comic.rating = 3
            }
        }
        
        NetworkManager.update(book: comic) { (response, error) in
            
            if error == nil {
                if response!["success"] == true {
                    print("Book has been successfully updated.")
                } else {
                    print("Failed to update book.")
                }
            } else {
                print("Failed to update book.")
            }
        }
    }
}
