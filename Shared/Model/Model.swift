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
    init(next: String?, previous: String?, results: [GameData]?) {
        self.next = next
        self.previous = previous
        self.results = results
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
    init(gameID: Int,
         name: String,
         released: String? = nil,
         backgroundImage: String? = nil,
         rating: Double? = nil,
         ratingTop: Int? = nil,
         parentPlatforms: [Item]? = nil,
         genres: [Item]? = nil) {
        self.gameID = gameID
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.ratingTop = ratingTop
        self.parentPlatforms = parentPlatforms
        self.genres = genres
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
    init(itemID: Int?, name: String?) {
        self.itemID = itemID
        self.name = name
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
    init(detailID: Int,
         name: String,
         released: String?,
         backgroundImage: String?,
         rating: Double?,
         ratingTop: Int?,
         parentPlatforms: [ParentPlatform]?,
         developers: [Item]?,
         genres: [Item]?,
         publishers: [Item]?,
         description: String) {
        self.detailID = detailID
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.ratingTop = ratingTop
        self.parentPlatforms = parentPlatforms
        self.developers = developers
        self.genres = genres
        self.publishers = publishers
        self.description = description
    }
}

// MARK: - ParentPlatform
struct ParentPlatform: Codable {
    let platform: Item
    init(platform: Item) {
        self.platform = platform
    }
}
