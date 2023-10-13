//
//  TvListOnTheAirModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 23.09.2023.
//

import Foundation

struct TvListOnTheAirModel: Codable {
    let results: [TvListOnTheAirResults]
}

struct TvListOnTheAirResults: Codable {
    let id: Int
    let bacdrop_path: String?
    let first_air_date: String
    let name: String
    let overview: String
    let poster_path: String?
    let vote_average: Double
}
