//
//  AiringTodayModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 23.09.2023.
//

import Foundation

struct TvListAiringTodayModel: Codable {
    let results: [TvListAiringTodayResults]
}

struct TvListAiringTodayResults: Codable {
    let id: Int
    let bacdrop_path: String?
    let first_air_date: String
    let name: String
    let overview: String
    let poster_path: String?
    let vote_average: Double
}
