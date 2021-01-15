//
//  MoviesManager.swift
//  FilmSearcher
//
//  Created by Sergey on 1/15/21.
//

import Foundation

protocol MoviesManagerDelegate: class {
    func didFailed(with error: Error)
    func didUpdateMovies(_ moviesManager: MoviesManager, moviesModel: MovieResult)
}

struct MoviesManager {
    
    weak var delagate: MoviesManagerDelegate?
    
    let baseURL = "https://www.omdbapi.com/?apikey=330741c4&type=movie"
    
    func getMovies(for query: String) {
        let finalQuery = query.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(baseURL)&s=\(finalQuery)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                guard let error = error else { return }
                delagate?.didFailed(with: error)
            }
            if let safeData = data {
                if let moviesModel = parseJSON(safeData) {
                    delagate?.didUpdateMovies(self, moviesModel: moviesModel)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> MovieResult? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MovieResult.self, from: data)
            let movieModel = MovieResult(Search: decodedData.Search)
            return movieModel
        } catch {
            delagate?.didFailed(with: error)
            return nil
        }
    }
    
}
