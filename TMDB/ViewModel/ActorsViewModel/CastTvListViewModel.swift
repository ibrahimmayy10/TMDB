//
//  CastTvListViewModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 24.09.2023.
//

import Foundation

class CastTvListViewModel {
    var tvListCast = [CastTvList]()
    
    func downloadCastTvList (id: Int, completion: @escaping () -> Void) {
        ActorsWebservices.shared.downloadCastTvList(id: id) { [weak self] tvListCast in
            if let tvListCast = tvListCast {
                self?.tvListCast = tvListCast
            }
            completion()
        }
    }
}
