//
//  Movie.swift
//  MyMoVieS
//
//  Created by Abdulloh on 01/08/24.
//

import Foundation

// MARK: - Film
struct MovieDetail: Decodable {
    let kinopoiskId: Int
    let imdbId: String?
    let nameRu: String?
    let nameEn: String?
    let description: String?
    let coverUrl: String?
    let countries: [Country]?
    let filmLength: Int?
    let genres: [Genre]?
    let nameOriginal: String?
    let posterUrl: String?
    let productionStatus: String?
    let ratingAwaitCount: Int?
    let ratingFilmCritics: Double?
    let ratingFilmCriticsVoteCount: Int?
    let ratingImdb: Double?
    let ratingImdbVoteCount: Int?
    let ratingKinopoiskVoteCount: Int?
    let reviewsCount: Int?
    let serial: Bool?
    let shortDescription: String?
    let shortFilm: Bool?
    let startYear: String?
    let type: String?
    let webUrl: String?
    let year: Int?
}
