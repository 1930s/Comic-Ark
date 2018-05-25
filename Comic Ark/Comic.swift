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
    
    init(jsonResponse: DecodedJSONResponse, isbn: String) {
        let decodedComic = jsonResponse.items[0]
        
        self.title = decodedComic.volumeInfo?.title
        self.isbn = isbn
        self.authors = decodedComic.volumeInfo?.authors
        self.publisher = decodedComic.volumeInfo?.publisher
        self.coverURL = URL(string: (decodedComic.volumeInfo?.imageLinks?.thumbnail)!)
        self.coverImage = nil
    }
}


enum Star {
    case one
    case two
    case three
}
