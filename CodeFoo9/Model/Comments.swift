//
//  Comments.swift
//  CodeFoo9
//
//  Created by hor kimleng on 3/9/19.
//  Copyright © 2019 hor kimleng. All rights reserved.
//

import Foundation

struct CommentResult: Decodable {
    let content: [Content]
}

struct Content: Decodable {
    let count: Int
}
