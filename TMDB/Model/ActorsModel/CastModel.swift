//
//  MovieActorsModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 23.09.2023.
//

import Foundation

struct CastModel: Codable {
    let cast: [CastMovie]
}

struct CastMovie: Codable {
    let name: String
    let character: String
    let profile_path: String?
}
