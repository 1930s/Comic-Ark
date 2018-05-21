//
//  JSON Response Model.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 14..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import Foundation

struct DecodedJSONResponse: Decodable {
    let items: [Volume]
}

struct Volume: Decodable {
    let volumeInfo: VolumeInfo?
}

struct VolumeInfo: Decodable {
    let title: String?
    let authors: [String]?
    let publisher: String?
    let categories: [String]?
    let imageLinks: ImageSize?
}

struct ImageSize: Decodable {
    let thumbnail: String
}
