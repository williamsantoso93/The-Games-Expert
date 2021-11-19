//
//  DetailInteractor.swift
//  The Games (iOS)
//
//  Created by iOS Dev on 11/18/21.
//

import Foundation
import Combine

protocol DetailUseCase {
    func getDetail(_ gameID: Int) -> AnyPublisher<DetailGame, Error>
    func getFavoriteList() -> AnyPublisher<[GameData], Error>
    func addFavorite(_ favorite: DetailGame) -> AnyPublisher<Bool, Error>
    func deleteFavorite(_ favorite: DetailGame) -> AnyPublisher<Bool, Error>
    func isFavorite(_ gameID: Int) -> AnyPublisher<Bool, Error>
}

class DetailInteractor: DetailUseCase {
    private let repository: GameRepositoryProtocol
    
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getFavoriteList() -> AnyPublisher<[GameData], Error> {
        return repository.getFavoriteList()
    }
    
    func getDetail(_ gameID: Int) -> AnyPublisher<DetailGame, Error> {
        repository.getDetail(gameID)
    }
    
    func addFavorite(_ favorite: DetailGame) -> AnyPublisher<Bool, Error> {
        repository.addFavorite(favorite)
    }
    
    func deleteFavorite(_ favorite: DetailGame) -> AnyPublisher<Bool, Error> {
        repository.deleteFavorite(favorite)
    }
    
    func isFavorite(_ gameID: Int) -> AnyPublisher<Bool, Error> {
        repository.isFavorite(gameID)
    }
}
