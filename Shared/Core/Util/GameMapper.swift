//
//  GameMapper.swift
//  The Games (iOS)
//
//  Created by iOS Dev on 11/19/21.
//

import Foundation

final class GameMapper {
    static func mapGenreEntityToItem(_ genreEntity: String) -> [Item]? {
        var genres: [Item]?
        if !genreEntity.isEmpty {
            if let genresData = genreEntity.data(using: .utf8) {
                genres = try? JSONDecoder().decode([Item].self, from: genresData)
            }
        }
        return genres
    }
    
    static func mapItemRepsonseToItem(_ itemReponse: [ItemResponse]?) -> [Item]? {
        if let itemReponse = itemReponse {
            return itemReponse.map { result in
                Item(itemID: result.itemID, name: result.name)
            }
        } else {
            return nil
        }
    }
    
    static func mapParentPlatformResponseToParentPlatform(_ parentPlatformResponse: [ParentPlatformResponse]?) -> [ParentPlatform]? {
        if let parentPlatformResponse = parentPlatformResponse {
            return parentPlatformResponse.map { result in
                ParentPlatform(platform: Item(itemID: result.platform.itemID, name: result.platform.name))
            }
        } else {
            return nil
        }
    }
    
    static func mapFavoriteListEntitiesToGameData(input favoriteList: [FavoriteEntity]) -> [GameData] {
        favoriteList.map { result in
            GameData(
                gameID: result.gameID,
                name: result.name,
                released: result.released,
                backgroundImage: result.backgroundImage,
                rating: result.rating,
                ratingTop: nil,
                parentPlatforms: nil,
                genres: mapGenreEntityToItem(result.genres)
            )
        }
    }
    
    static func mapDetailGameToFavoriteListEntities(input detailGame: DetailGame) -> FavoriteEntity {
        let favoriteEntity = FavoriteEntity()
        favoriteEntity.favoriteID = UUID().uuidString
        favoriteEntity.timestamp = Date()
        favoriteEntity.gameID = Int(detailGame.detailID)
        favoriteEntity.name = detailGame.name
        favoriteEntity.rating = detailGame.rating ?? 0
        favoriteEntity.backgroundImage = detailGame.backgroundImage ?? ""
        favoriteEntity.released = detailGame.released ?? ""
        return favoriteEntity
    }
    
    static func mapGameDataResponsesToGamedata(input gameDataResponse: [GameDataResponse]) -> [GameData] {
        gameDataResponse.map { result in
            GameData(
                gameID: result.gameID,
                name: result.name,
                released: result.released,
                backgroundImage: result.backgroundImage,
                rating: result.rating,
                ratingTop: result.ratingTop,
                parentPlatforms: mapItemRepsonseToItem(result.parentPlatforms),
                genres: mapItemRepsonseToItem(result.genres)
            )
        }
    }
    
    static func mapDetailGameResponsesToDetailGame(input detailDataResponse: DetailGameResponse) -> DetailGame {
        DetailGame(
            detailID: detailDataResponse.detailID,
            name: detailDataResponse.name,
            released: detailDataResponse.released,
            backgroundImage: detailDataResponse.backgroundImage,
            rating: detailDataResponse.rating,
            ratingTop: detailDataResponse.ratingTop,
            parentPlatforms: mapParentPlatformResponseToParentPlatform(detailDataResponse.parentPlatforms),
            developers: mapItemRepsonseToItem(detailDataResponse.developers),
            genres: mapItemRepsonseToItem(detailDataResponse.genres),
            publishers: mapItemRepsonseToItem(detailDataResponse.publishers),
            description: detailDataResponse.description)
    }
}
