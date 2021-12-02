//
//  GameResponse.swift
//  The Games (iOS)
//
//  Created by iOS Dev on 11/19/21.
//

import Foundation

// MARK: - ListGames
struct GamesListResponse: Codable {
    let next: String?
    let previous: String?
    let results: [GameDataResponse]?
    
    enum CodingKeys: String, CodingKey {
        case next, previous, results
    }
}

// MARK: - Result
struct GameDataResponse: Codable {
    var gameID: Int
    var name: String
    var released: String?
    var backgroundImage: String?
    var rating: Double?
    var ratingTop: Int?
    var parentPlatforms: [ItemResponse]?
    var genres: [ItemResponse]?
    
    enum CodingKeys: String, CodingKey {
        case gameID = "id"
        case name, released
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case parentPlatforms = "parent_platforms"
        case genres
    }
}

// MARK: - Item
struct ItemResponse: Codable {
    let itemID: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case itemID = "id"
        case name
    }
}

// MARK: - DetailGame
struct DetailGameResponse: Codable {
    let detailID: Int
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let parentPlatforms: [ParentPlatformResponse]?
    let developers: [ItemResponse]?
    let genres: [ItemResponse]?
    let publishers: [ItemResponse]?
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case detailID = "id"
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case parentPlatforms = "parent_platforms"
        case developers
        case genres
        case publishers
        case description = "description_raw"
    }
}

// MARK: - ParentPlatform
struct ParentPlatformResponse: Codable {
    let platform: ItemResponse
}
