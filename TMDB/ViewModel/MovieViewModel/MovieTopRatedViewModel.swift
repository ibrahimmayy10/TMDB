//
//  MovieTopRatedViewModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 22.09.2023.
//

import Foundation

class MovieTopRatedViewModel {
    var topRatedResults = [MovieTopRatedResults]()
    
    func downloadTopRatedMovie(completion: @escaping () -> Void ) {
        Webservices.shared.downloadTopRatedMovie { [weak self] results in
            if let results = results {
                self?.topRatedResults = results
            }
            completion()
        }
    }
}
