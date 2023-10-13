//
//  MovieActorViewModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 23.09.2023.
//

import Foundation

class CastViewModel {
    var cast = [CastMovie]()
    
    func downloadCastMovie(id: Int, completion: @escaping () -> Void ) {
        ActorsWebservices.shared.downloadCastMovie(id: id) { [weak self] cast in
            if let cast = cast {
                self?.cast = cast
            }
            completion()
        }
    }
}
