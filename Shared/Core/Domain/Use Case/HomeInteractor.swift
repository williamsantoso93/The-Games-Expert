//
//  HomeInteractor.swift
//  The Games (iOS)
//
//  Created by iOS Dev on 11/18/21.
//

import Foundation
import Combine

protocol HomeUseCase {
    func getListGames(nextPage: String?, searchText: String) -> AnyPublisher<GamesListResponse, Error>
}

class HomeInteractor: HomeUseCase {
    private let repository: GameRepositoryProtocol
    
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getListGames(nextPage: String?, searchText: String) -> AnyPublisher<GamesListResponse, Error> {
        return repository.getListGames(nextPage: nextPage, searchText: searchText)
    }
}
