//
//  GameModel.swift
//  The Games
//
//  Created by William Santoso on 14/08/21.
//

import Foundation

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
}

// MARK: - Item
struct Item: Codable {
    let itemID: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case itemID = "id"
        case name
    }
}

// MARK: - ParentPlatform
struct ParentPlatform: Codable {
    let platform: Item
}
