//
//  Movies.swift
//  FilmSearcher
//
//  Created by Sergey on 12/1/20.
//

import Foundation

struct Movie: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let _Type: String
    let Poster: String
    
    private enum CodingKeys: String, CodingKey {
        case Title, Year, imdbID, _Type = "Type", Poster
    }
}

struct MovieResult: Codable {
    let Search: [Movie]
}


