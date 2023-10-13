//
//  MovieViewModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 20.09.2023.
//

import Foundation

class MovieViewModel {
    var results = [Results]()
    
    func downloadMovie(completion: @escaping () -> Void ) {
        Webservices.shared.downloadMovie { [weak self] results in
            if let results = results {
                self?.results = results
            }
            completion()
        }
    }
}
