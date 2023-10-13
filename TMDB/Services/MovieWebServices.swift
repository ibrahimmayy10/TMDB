//
//  WebServices.swift
//  TMDB
//
//  Created by İbrahim Ay on 20.09.2023.
//

import Foundation

enum MovieError: Error {
    case serverError
    case parsingError
}

class Webservices {
    static let shared = Webservices()
    
    func downloadMovie (completion: @escaping ([Results]?) -> Void ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=3e4dbb0176e7f36f4df0a3b954f5a609") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MovieModel.self, from: data)
                completion(response.results)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func downloadNowPlayingMovie (completion: @escaping ([OnDisplayResults]?) -> Void ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=3e4dbb0176e7f36f4df0a3b954f5a609") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let displayMovieResults = try JSONDecoder().decode(MovieOnDisplayModel.self, from: data)
                completion(displayMovieResults.results)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func downloadTopRatedMovie (completion: @escaping ([MovieTopRatedResults]?) -> Void ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=3e4dbb0176e7f36f4df0a3b954f5a609") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let topRatedResults = try JSONDecoder().decode(MovieTopRatedModel.self, from: data)
                completion(topRatedResults.results)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func downloadUpcoming (completion: @escaping ([UpcomingResults]?) -> Void ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=3e4dbb0176e7f36f4df0a3b954f5a609") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let upcomingResults = try JSONDecoder().decode(UpcomingModel.self, from: data)
                completion(upcomingResults.results)
            } catch {
                completion(nil)
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func downloadComment(url: URL, completion: @escaping (Result<[CommentResults]?, MovieError>) -> Void ) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.serverError))
            } else if let data = data {
                let commentResults = try? JSONDecoder().decode(CommentModel.self, from: data)
                let comment = commentResults?.results
                completion(.success(comment))
            }
        }.resume()
    }
    
}
