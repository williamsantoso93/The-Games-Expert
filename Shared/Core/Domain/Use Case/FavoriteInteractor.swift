//
//  FavoriteInteractor.swift
//  The Games (iOS)
//
//  Created by iOS Dev on 11/19/21.
//

import Foundation
import Combine

protocol FavoriteUseCase {
    func getFavoriteList() -> AnyPublisher<[GameData], Error>
}

class FavoriteInteractor: FavoriteUseCase {
    private let repository: GameRepositoryProtocol
    
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
        
    func getFavoriteList() -> AnyPublisher<[GameData], Error> {
        return repository.getFavoriteList()
    }
}
