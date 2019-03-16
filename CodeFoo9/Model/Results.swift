//
//  Results.swift
//  CodeFoo9
//
//  Created by hor kimleng on 3/9/19.
//  Copyright © 2019 hor kimleng. All rights reserved.
//

import Foundation

struct Results: Decodable {
    let data: [DataResults]
}

struct DataResults: Decodable {
    let contentId: String
    let contentType: String
    let metadata: MetaData
    let thumbnails: [ImageData]
}

struct MetaData: Decodable {
    let headline: String?
    let title: String?
    let description: String?
    let publishDate: String
}

struct ImageData: Decodable {
    let url: String
}
