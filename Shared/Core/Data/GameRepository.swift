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
}

class GameRepository {
    typealias GameInstance = (RemoteDataSource) -> GameRepository
    
    fileprivate let remote: RemoteDataSource
    
    private init(remote: RemoteDataSource) {
      self.remote = remote
    }
    
    static let sharedInstance: GameInstance = { remoteRepo in
      return GameRepository(remote: remoteRepo)
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
}
