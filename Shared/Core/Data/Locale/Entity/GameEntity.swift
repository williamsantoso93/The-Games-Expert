//
//  GameEntity.swift
//  The Games (iOS)
//
//  Created by iOS Dev on 11/19/21.
//

import Foundation
import RealmSwift

class FavoriteEntity: Object {
    @objc dynamic var gameID: Int = 0
    @objc dynamic var backgroundImage: String? = ""
    @objc dynamic var favoriteID: String = UUID().uuidString
    @objc dynamic var genres: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var rating: Double = 0
    @objc dynamic var released: String? = ""
    @objc dynamic var timestamp: Date = Date()
    
    override static func primaryKey() -> String? {
      return "favoriteID"
    }
}
