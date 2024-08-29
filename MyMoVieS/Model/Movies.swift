//
//  Movies.swift
//  MyMoVieS
//
//  Created by Abdulloh on 30/07/24.
//

import Foundation

// Define the top-level response
struct MoviesResponse: Codable {
    let pagesCount: Int
    let films: [Film]
}

struct SearchMoviesResponse: Codable {
    let keyword: String
    let pagesCount: Int
    let films: [Film]
    let searchFilmsCountResult: Int
}

// Define the Film model
//struct Film: Codable, Hashable {
//    let filmId: Int
//    let nameRu: String?
//    let nameEn: String?
//    let year: String
//    let filmLength: String?
//    let countries: [Country]
//    let genres: [Genre]
//    let rating: String?
//    let ratingVoteCount: Int
//    let posterUrl: String
//    let posterUrlPreview: String
//    let ratingChange: String?
//    let isRatingUp: Bool?
//    let isAfisha: Int
//}

struct Film: Codable, Hashable {
    let filmId: Int
    let nameRu: String?
    let nameEn: String?
    let year: String?
    let filmLength: String?
    let countries: [Country]?
    let genres: [Genre]?
    let rating: String?
    let ratingVoteCount: Int?
    let posterUrl: String?
    let posterUrlPreview: String?
    let ratingChange: String?
    let isRatingUp: Bool?
    let isAfisha: Int?
}


// Define the Country model
struct Country: Codable, Hashable {
    let country: String?
}

// Define the Genre model
struct Genre: Codable, Hashable {
    let genre: String?
}
