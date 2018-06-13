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
    var coverImage: UIImage? = nil
    var rating: Int = 0
    
    init(jsonResponse: GoogleBooksResponse, isbn: String) {
        let decodedComic = jsonResponse.items[0]
        
        self.title = decodedComic.volumeInfo?.title ?? "Unknown"
        self.isbn = isbn
        self.authors = decodedComic.volumeInfo?.authors ?? ["Unknown"]
        self.publisher = decodedComic.volumeInfo?.publisher
        self.coverUrl = decodedComic.volumeInfo?.imageLinks?.thumbnail
        
        if coverUrl != nil {
            downloadImage()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case isbn
        case authors
        case publisher
        case coverUrl
        case rating
    }
    
    private func downloadImage() {
        
        URLSession.shared.dataTask(with: URL(string: coverUrl!)!, completionHandler: { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 && error == nil && data != nil {
                    self.coverImage = UIImage(data: data!)
                }
            }
        }).resume()
    }
}
