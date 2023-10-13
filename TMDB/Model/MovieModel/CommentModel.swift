//
//  CommentModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 21.09.2023.
//

import Foundation

struct CommentModel: Codable {
    let results: [CommentResults]
}

struct CommentResults: Codable {
    let content: String
    let author: String
}
