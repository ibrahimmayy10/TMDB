//
//  ActorsDetailsModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 23.09.2023.
//

import Foundation

struct ActorsMoviesModel: Codable {
    let cast: [Cast]
}

struct Cast: Codable {
    let id: Int
    let title: String
    let vote_average: Double
    let poster_path: String?
    let overview: String
    let release_date: String
}
