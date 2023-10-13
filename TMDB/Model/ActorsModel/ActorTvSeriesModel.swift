//
//  ActorTvSeriesModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 23.09.2023.
//

import Foundation

struct ActorTvSeriesModel: Codable {
    let cast: [TvSeriesCast]
}

struct TvSeriesCast: Codable {
    let id: Int
    let name: String
    let vote_average: Double
    let poster_path: String?
    let overview: String
    let first_air_date: String
}
