//
//  MovieModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 20.09.2023.
//

import Foundation

struct MovieModel: Codable {
    let results: [Results]
}

struct Results: Codable {
    let id: Int
    let backdrop_path: String?
    let title: String
    let overview: String
    let poster_path: String?
    let release_date: String
    let vote_average: Double
}
