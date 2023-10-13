//
//  ActorsWebservices.swift
//  TMDB
//
//  Created by İbrahim Ay on 23.09.2023.
//

import Foundation

class ActorsWebservices {
    static let shared = ActorsWebservices()
    
    func downloadActors (completion: @escaping ([ActorsResults]?) -> Void ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/person/popular?api_key=3e4dbb0176e7f36f4df0a3b954f5a609") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let actors = try JSONDecoder().decode(ActorsModel.self, from: data)
                completion(actors.results)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func downloadActorsMovie (id: Int, completion: @escaping ([Cast]?) -> Void ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/person/\(id)/movie_credits?api_key=3e4dbb0176e7f36f4df0a3b954f5a609") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let actorMovies = try JSONDecoder().decode(ActorsMoviesModel.self, from: data)
                completion(actorMovies.cast)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func downloadActorsTvSeries (id: Int, completion: @escaping ([TvSeriesCast]?) -> Void ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/person/\(id)/tv_credits?api_key=3e4dbb0176e7f36f4df0a3b954f5a609") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let actorTvSeries = try JSONDecoder().decode(ActorTvSeriesModel.self, from: data)
                completion(actorTvSeries.cast)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func downloadCastMovie(id: Int, completion: @escaping ([CastMovie]?) -> Void ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=3e4dbb0176e7f36f4df0a3b954f5a609") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let cast = try JSONDecoder().decode(CastModel.self, from: data)
                completion(cast.cast)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func downloadCastTvList (id: Int, completion: @escaping ([CastTvList]?) -> Void ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/\(id)/credits?api_key=3e4dbb0176e7f36f4df0a3b954f5a609") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let tvListCast = try JSONDecoder().decode(TvListCastModel.self, from: data)
                completion(tvListCast.cast)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
}
