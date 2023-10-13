//
//  ViewModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 22.09.2023.
//

import Foundation

struct MovieOnDisplayModel: Codable {
    let results: [OnDisplayResults]
}

struct OnDisplayResults: Codable {
    let id: Int
    let backdrop_path: String?
    let title: String
    let overview: String
    let poster_path: String?
    let release_date: String
    let vote_average: Double
}
