//
//  GameRepository.swift
//  The Games (iOS)
//
//  Created by iOS Dev on 11/18/21.
//

import Foundation
import Combine

protocol GameRepositoryProtocol {
    func getListGames(nextPage: String?, searchText: String) -> AnyPublisher<DataResult, NetworkError>
    func getDetail(_ gameID: Int) -> AnyPublisher<DetailGame, NetworkError>
    func getFavoriteList() -> AnyPublisher<[GameData], Error>
    func addFavorite(game: DetailGame) -> AnyPublisher<Bool, Error>
}

class GameRepository {
    typealias GameInstance = (LocaleDataSource, RemoteDataSource) -> GameRepository
    
    fileprivate let remote: RemoteDataSource
    fileprivate let locale: LocaleDataSource
    
    private init(locale: LocaleDataSource, remote: RemoteDataSource) {
      self.locale = locale
      self.remote = remote
    }
    
    static let sharedInstance: GameInstance = { localeRepo, remoteRepo in
      return GameRepository(locale: localeRepo, remote: remoteRepo)
    }
}

extension GameRepository: GameRepositoryProtocol {
    func getListGames(nextPage: String? = nil, searchText: String) -> AnyPublisher<DataResult, NetworkError> {
        return remote.getListGames(nextPage: nextPage, searchText: searchText)
            .eraseToAnyPublisher()
    }
    
    func getDetail(_ gameID: Int) -> AnyPublisher<DetailGame, NetworkError> {
        return remote.getDetail(gameID)
            .eraseToAnyPublisher()
    }
    
    func getFavoriteList() -> AnyPublisher<[GameData], Error> {
        return locale.getFavoriteList()
            .eraseToAnyPublisher()
    }
    
    func addFavorite(game: DetailGame) -> AnyPublisher<Bool, Error> {
        return locale.addFavorite(game: game)
            .eraseToAnyPublisher()
    }
}
