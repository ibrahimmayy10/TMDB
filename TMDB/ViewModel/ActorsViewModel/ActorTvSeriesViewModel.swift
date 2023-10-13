//
//  ActorTvSeriesViewModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 23.09.2023.
//

import Foundation

class ActorsTvSeriesViewModel {
    var actorTvSeries = [TvSeriesCast]()
    
    func downloadActorsTvSeries(id: Int, completion: @escaping () -> Void ) {
        ActorsWebservices.shared.downloadActorsTvSeries(id: id) { [weak self] castTvSeries in
            if let cast = castTvSeries {
                self?.actorTvSeries = cast
            }
            completion()
        }
    }
}
