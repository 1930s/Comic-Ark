//
//  Comic.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 07..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import Foundation
import UIKit

class Comic {
    let title: String
    let author: String
    let cover: UIImage
    var rating: Star
    
    init(name: String, author: String, cover: UIImage, rating: Star) {
        self.title = name
        self.author = author
        self.cover = cover
        self.rating = rating
    }
}

enum Star {
    case oneStar
    case twoStars
    case threeStars
}
