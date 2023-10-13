//
//  UpcomingModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 22.09.2023.
//

import Foundation

struct UpcomingModel: Codable {
    let results: [UpcomingResults]
}

struct UpcomingResults: Codable {
    let title: String
    let id: Int
    let release_date: String
    let poster_path: String
    let vote_average: Double
    let overview: String
}
