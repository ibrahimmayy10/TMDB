//
//  ActorsDetailsViewModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 23.09.2023.
//

import Foundation

class ActorsMoviesViewModel {
    var actorMovies = [Cast]()
    
    func downloadActorsMovie(id: Int, completion: @escaping () -> Void ) {
        ActorsWebservices.shared.downloadActorsMovie(id: id) { [weak self] cast in
            if let cast = cast {
                self?.actorMovies = cast
            }
            completion()
        }
    }
}
