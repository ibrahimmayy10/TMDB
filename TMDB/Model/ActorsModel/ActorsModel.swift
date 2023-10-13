//
//  ActorsModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 23.09.2023.
//

import Foundation

struct ActorsModel: Codable {
    let results: [ActorsResults]
}

struct ActorsResults: Codable {
    let id: Int
    let known_for_department: String
    let name: String
    let profile_path: String?
}
