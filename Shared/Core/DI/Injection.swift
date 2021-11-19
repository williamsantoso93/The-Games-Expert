//
//  Injection.swift
//  The Games (iOS)
//
//  Created by iOS Dev on 11/18/21.
//

import Foundation

final class Injection: NSObject {
    private func provideRepository() -> GameRepositoryProtocol {
        let remote: RemoteDataSource = RemoteDataSource.sharedInstance
        
        return GameRepository.sharedInstance(remote)
    }
    
    func provideHome() -> HomeUseCase {
        let repository = provideRepository()
        return HomeInteractor(repository: repository)
    }
    
    func provideDetail(gamedID: Int) -> DetailUseCase {
        let repository = provideRepository()
        return DetailInteractor(repository: repository)
    }
}
