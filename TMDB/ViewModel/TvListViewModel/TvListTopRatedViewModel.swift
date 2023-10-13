//
//  TvListTopRatedViewModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 23.09.2023.
//

import Foundation

class TvListTopRatedViewModel {
    var tvListTopRatedResults = [TvListTopRatedResults]()
    
    func downloadTopRatedTvList(completion: @escaping () -> Void ) {
        TvListWebservices.shared.downloadTopRatedTvList { [weak self] results in
            if let results = results {
                self?.tvListTopRatedResults = results
            }
            completion()
        }
    }
}
