//
//  Trailers.swift
//  MyMoVieS
//
//  Created by Abdulloh on 02/08/24.
//

import Foundation

// Define a struct to represent each item
struct TrailerItem: Codable {
    let url: String?
    let name: String?
    let site: String?
}

// Define a struct to represent the response containing the total and array of items
struct TrailerResponse: Codable {
    let total: Int
    let items: [TrailerItem]
}
