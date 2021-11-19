//
//  DetailInteractor.swift
//  The Games (iOS)
//
//  Created by iOS Dev on 11/18/21.
//

import Foundation
import Combine

protocol DetailUseCase {
    func getDetail(_ gameID: Int) -> AnyPublisher<DetailGame, NetworkError>
}

class DetailInteractor: DetailUseCase {
    private let repository: GameRepositoryProtocol
    
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getDetail(_ gameID: Int) -> AnyPublisher<DetailGame, NetworkError> {
        return repository.getDetail(gameID)
    }
}
