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
    var rating: Star? = nil
    
    init(title: String?, isbn: String, authors: [String]?, publisher: String?, coverURL: URL?) {
        self.title = title
        self.isbn = isbn
        self.authors = authors
        self.publisher = publisher
        self.coverURL = coverURL
    }
}



enum Star {
    case one
    case two
    case three
}
