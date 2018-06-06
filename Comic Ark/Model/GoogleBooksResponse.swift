//
//  JSON Response Model.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 14..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import Foundation
import UIKit

struct GoogleBooksResponse: Codable {
    let items: [Volume]
}

struct Volume: Codable {
    let volumeInfo: VolumeInfo?
}

struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let publisher: String?
    let categories: [String]?
    let imageLinks: ImageSize?
}

struct ImageSize: Codable {
    let thumbnail: String
}
