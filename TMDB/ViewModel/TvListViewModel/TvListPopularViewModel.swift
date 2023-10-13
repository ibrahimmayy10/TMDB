//
//  TvListPopularViewModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 22.09.2023.
//

import Foundation

class TvListPopularViewModel {
    var tvListPopularResults = [TvListPopularResults]()
    
    func downloadPopularTvList(completion: @escaping () -> Void ) {
        TvListWebservices.shared.downloadPopularTvList { [weak self] results in
            if let results = results {
                self?.tvListPopularResults = results
            }
            completion()
        }
    }
}
