//
//  AiringTodayViewModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 23.09.2023.
//

import Foundation

class TvListAiringTodayViewModel {
    var tvListAiringTodayResults = [TvListAiringTodayResults]()
    
    func downloadAiringTodayTvList(completion: @escaping () -> Void ) {
        TvListWebservices.shared.downloadAiringTodayTvList { [weak self] results in
            if let results = results {
                self?.tvListAiringTodayResults = results
            }
            completion()
        }
    }
}
