//
//  TvListOnTheAirViewModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 23.09.2023.
//

import Foundation

class TvListOnTheAirViewModel {
    var tvListOnTheAirResults = [TvListOnTheAirResults]()
    
    func downloadOnTheAirTvList(completion: @escaping () -> Void ) {
        TvListWebservices.shared.downloadOnTheAirTvList { [weak self] results in
            if let results = results {
                self?.tvListOnTheAirResults = results
            }
            completion()
        }
    }
}
