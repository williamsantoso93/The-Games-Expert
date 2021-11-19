//
//  LocaleDataSource.swift
//  The Games (iOS)
//
//  Created by iOS Dev on 11/19/21.
//

import SwiftUI
import CoreData
import Combine

protocol LocaleDataSourceProtocol {
    func getFavoriteList() -> AnyPublisher<[GameData], Error>
    func addFavorite(game: DetailGame) -> AnyPublisher<Bool, Error>
}

final class LocaleDataSource: NSObject {
    @Environment(\.managedObjectContext) var moc
    
    static let sharedInstance = LocaleDataSource()
}

extension LocaleDataSource: LocaleDataSourceProtocol {
    func getFavoriteList() -> AnyPublisher<[GameData], Error> {
        return Future<[GameData], Error> { completion in
//            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
//            do {
//                let results = try self.moc.fetch(fetchRequest) as? [Favorite]
//
//                if let results = results {
//                    var temp: [GameData] = []
//                    for result in results {
//                        var genres: [Item]?
//                        if let genresData = result.genres?.data(using: .utf8) {
//                            genres = try? JSONDecoder().decode([Item].self, from: genresData)
//                        }
//                        let gameData: GameData = .init(gameID: Int(result.gameID), name: result.name ?? "-", released: result.released ?? "-", backgroundImage: result.backgroundImage, rating: result.rating, ratingTop: nil, parentPlatforms: nil, genres: genres)
//                        temp.append(gameData)
//                    }
//                    completion(.success(temp))
//                } else {
                    completion(.failure(NetworkError.noData))
//                }
//            } catch let error {
//                completion(.failure(error))
//            }
        }.eraseToAnyPublisher()
    }
    
    func addFavorite(game: DetailGame) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            let favorite = Favorite(context: self.moc)
            favorite.favoriteID = UUID()
            favorite.timestamp = Date()
            favorite.gameID = Int64(game.detailID)
            favorite.name = game.name
            favorite.rating = game.rating ?? 0
            favorite.backgroundImage = game.backgroundImage
            favorite.released = game.released
            if let genresData = try? JSONEncoder().encode(game.genres) {
                favorite.genres = String(data: genresData, encoding: .utf8)
            }
            PersistenceController.shared.save()
            completion(.success(true))
        }.eraseToAnyPublisher()
    }
}
