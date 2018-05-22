//
//  Comic.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 07..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import Foundation
import UIKit

struct Comic {
    let title: String?
    let isbn: String
    let authors: [String]?
    let publisher: String?
    let coverURL: URL?
    let coverImage: UIImage?
    var rating: Star? = nil
    
    init(title: String?, isbn: String, authors: [String]?, publisher: String?, coverURL: URL?, coverImage: UIImage?) {
        self.title = title
        self.isbn = isbn
        self.authors = authors
        self.publisher = publisher
        self.coverURL = coverURL
        self.coverImage = coverImage
    }
}



enum Star {
    case one
    case two
    case three
}
