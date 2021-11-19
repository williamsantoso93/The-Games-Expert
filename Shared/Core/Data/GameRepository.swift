//
//  GameRepository.swift
//  The Games (iOS)
//
//  Created by iOS Dev on 11/18/21.
//

import Foundation
import Combine

protocol GameRepositoryProtocol {
    func getListGames(nextPage: String?, searchText: String) -> AnyPublisher<GamesListResponse, Error>
    func getFavoriteList() -> AnyPublisher<[GameData], Error>
    func getDetail(_ gameID: Int) -> AnyPublisher<DetailGame, Error>
    func addFavorite(_ favorite: DetailGame) -> AnyPublisher<Bool, Error>
    func deleteFavorite(_ favorite: DetailGame) -> AnyPublisher<Bool, Error>
    func isFavorite(_ gameID: Int) -> AnyPublisher<Bool, Error> 
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
    func getListGames(nextPage: String? = nil, searchText: String) -> AnyPublisher<GamesListResponse, Error> {
        remote.getListGames(nextPage: nextPage, searchText: searchText)
            .eraseToAnyPublisher()
    }
    
    func getDetail(_ gameID: Int) -> AnyPublisher<DetailGame, Error> {
        remote.getDetail(gameID)
            .map { GameMapper.mapDetailGameResponsesToDetailGame(input: $0)}
            .eraseToAnyPublisher()
    }
    
    func getFavoriteList() -> AnyPublisher<[GameData], Error> {
        self.locale.getFavoriteList()
            .map { GameMapper.mapFavoriteListEntitiesToGameData(input: $0) }
            .eraseToAnyPublisher()
    }
    
    func addFavorite(_ favorite: DetailGame) -> AnyPublisher<Bool, Error> {
        let favoriteEntity = GameMapper.mapDetailGameToFavoriteListEntities(input: favorite)
        return self.locale.addFavorite(favoriteEntity)
            .eraseToAnyPublisher()
    }
    
    func deleteFavorite(_ favorite: DetailGame) -> AnyPublisher<Bool, Error> {
        let favoriteEntity = GameMapper.mapDetailGameToFavoriteListEntities(input: favorite)
        return self.locale.deleteFavorite(favoriteEntity)
            .eraseToAnyPublisher()
    }
    
    func isFavorite(_ gameID: Int) -> AnyPublisher<Bool, Error> {
        var cancellables: Set<AnyCancellable> = []
        return Future<Bool, Error> { completionHandler in
            self.locale.getFavoriteList()
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }, receiveValue: { data in
                    let index = data.firstIndex {
                        $0.gameID == gameID
                    }
                    if index != nil {
                        completionHandler(.success(true))
                    } else {
                        completionHandler(.success(false))
                    }
                })
                .store(in: &cancellables)
        }.eraseToAnyPublisher()
    }
}
