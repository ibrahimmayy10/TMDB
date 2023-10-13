//
//  TvListWebServices.swift
//  TMDB
//
//  Created by İbrahim Ay on 22.09.2023.
//

import Foundation

class TvListWebservices {
    static let shared = TvListWebservices()
    
    func downloadPopularTvList (completion: @escaping ([TvListPopularResults]?) -> Void ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/popular?api_key=3e4dbb0176e7f36f4df0a3b954f5a609") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let tvListPopularResults = try JSONDecoder().decode(TvListPopularModel.self, from: data)
                completion(tvListPopularResults.results)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func downloadOnTheAirTvList (completion: @escaping ([TvListOnTheAirResults]?) -> Void ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/on_the_air?api_key=3e4dbb0176e7f36f4df0a3b954f5a609") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let tvListOnTheAirResults = try JSONDecoder().decode(TvListOnTheAirModel.self, from: data)
                completion(tvListOnTheAirResults.results)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func downloadAiringTodayTvList (completion: @escaping ([TvListAiringTodayResults]?) -> Void ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/airing_today?api_key=3e4dbb0176e7f36f4df0a3b954f5a609") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let tvListOnTheAirResults = try JSONDecoder().decode(TvListAiringTodayModel.self, from: data)
                completion(tvListOnTheAirResults.results)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func downloadTopRatedTvList (completion: @escaping ([TvListTopRatedResults]?) -> Void ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/top_rated?api_key=3e4dbb0176e7f36f4df0a3b954f5a609") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let topRated = try JSONDecoder().decode(TvListTopRatedModel.self, from: data)
                completion(topRated.results)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
