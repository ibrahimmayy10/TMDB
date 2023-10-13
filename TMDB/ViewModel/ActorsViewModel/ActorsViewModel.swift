//
//  ActorsViewModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 23.09.2023.
//

import Foundation

class ActorsViewModel {
    var actors = [ActorsResults]()
    
    func downloadActors(completion: @escaping () -> Void ) {
        ActorsWebservices.shared.downloadActors { [weak self] actors in
            if let actors = actors {
                self?.actors = actors
            }
            completion()
        }
    }
}
