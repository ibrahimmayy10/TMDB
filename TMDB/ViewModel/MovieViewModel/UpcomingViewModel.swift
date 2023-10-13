//
//  UpcomingViewModel.swift
//  TMDB
//
//  Created by İbrahim Ay on 22.09.2023.
//

import Foundation

class UpcomingViewModel {
    var upcomingResults = [UpcomingResults]()
    
    func downloadUpcoming (completion: @escaping () -> Void ) {
        Webservices.shared.downloadUpcoming { [weak self] results in
            if let results = results {
                self?.upcomingResults = results
            }
            completion()
        }
    }
}
