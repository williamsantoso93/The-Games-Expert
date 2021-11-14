//
//  Model.swift
//  The Games
//
//  Created by William Santoso on 14/08/21.
//

import Foundation

// MARK: - ListGames
struct DataResult: Codable {
    let next: String?
    let previous: String?
    let results: [GameData]?
    enum CodingKeys: String, CodingKey {
        case next, previous, results
    }
}

// MARK: - Result
struct GameData: Codable {
    var gameID: Int
    var name: String
    var released: String?
    var releasedDate: Date? {
        if let released = released {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.date(from: released)!
        }
        return nil
    }
    var backgroundImage: String?
    var rating: Double?
    var ratingTop: Int?
    var parentPlatforms: [Item]?
    var genres: [Item]?
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

// MARK: - Platform
struct Item: Codable {
    let itemID: Int?
    let name: String?
    enum CodingKeys: String, CodingKey {
        case itemID = "id"
        case name
    }
}

// MARK: - DetailGame
struct DetailGame: Codable {
    let detailID: Int
    let name: String
    let released: String?
    var releasedDate: Date? {
        if let released = released {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.date(from: released)!
        }
        return nil
    }
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let parentPlatforms: [ParentPlatform]?
    let developers: [Item]?
    let genres: [Item]?
    let publishers: [Item]?
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
struct ParentPlatform: Codable {
    let platform: Item
}
