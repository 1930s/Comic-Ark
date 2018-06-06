//
//  Comic.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 07..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import Foundation
import UIKit

class Comic: Codable {
    let title: String
    let isbn: String
    let authors: [String]
    let publisher: String?
    let coverUrl: String?
//    let coverImage: UIImage?
    var rating: Int = 0
    
    
    
    init(jsonResponse: GoogleBooksResponse, isbn: String) {
        let decodedComic = jsonResponse.items[0]
        
        self.title = decodedComic.volumeInfo?.title ?? "Unknown"
        self.isbn = isbn
        self.authors = decodedComic.volumeInfo?.authors ?? ["Unknown"]
        self.publisher = decodedComic.volumeInfo?.publisher
        self.coverUrl = decodedComic.volumeInfo?.imageLinks?.thumbnail
//        self.coverImage = UIImage(url: URL(string: coverUrl!))
    }
}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url). Error: \(error)")
            return nil
        }
    }
}
