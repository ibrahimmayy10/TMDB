//
//  MovieOnDisplayViewModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 22.09.2023.
//

import Foundation

class MovieDisplayViewModel {
    var resultsDisplay = [OnDisplayResults]()
    
    func downloadNowPlayingMovie(completion: @escaping () -> Void ) {
        Webservices.shared.downloadNowPlayingMovie { [weak self] results in
            if let results = results {
                self?.resultsDisplay = results
            }
            completion()
        }
    }
}
