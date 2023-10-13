//
//  TvListCastModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 24.09.2023.
//

import Foundation

struct TvListCastModel: Codable {
    let cast: [CastTvList]
}

struct CastTvList: Codable {
    let name: String
    let character: String
    let profile_path: String?
}
