//
//  DetailViewModel.swift
//  The Games
//
//  Created by William Santoso on 15/08/21.
//

import SwiftUI
import CoreData
import Combine

class DetailViewModel: ObservableObject {
    private let detailUseCase: DetailUseCase
    
    @Published var gameID: Int
    @Published var game: DetailGame?
    @Published var isLoading = false
    @Published var message = "Error please try again"
    private var cancellables: Set<AnyCancellable> = []
    
    init(gameID: Int, detailUseCase: DetailUseCase) {
        self.detailUseCase = detailUseCase
        self.gameID = gameID
        self.getGameDetail()
    }
        
    func getGameDetail() {
        isLoading = true
        detailUseCase.getDetail(gameID)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure(let error):
                    self.message = "Error please try again"
                    print(error.localizedDescription)
                }
            }, receiveValue: { data in
                self.game = data
            })
            .store(in: &cancellables)
    }
    
    func addFavorite(_ moc: NSManagedObjectContext) {
        if let game = game {
            detailUseCase.addFavorite(game: game)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        self.isLoading = false
                    case .failure(let error):
                        self.message = "Error please try again"
                        print(error.localizedDescription)
                    }
                }, receiveValue: { _ in
                })
                .store(in: &cancellables)
        }
    }
    
    func deleteFavorite(_ moc: NSManagedObjectContext, _ results: FetchedResults<Favorite>) {
        if let index = getIndex(results) {
            let favorite = results[index]
            moc.delete(favorite)
        }
    }
    
    func isFavorite(results: FetchedResults<Favorite>) -> Bool {
        if getIndex(results) != nil {
            return true
        }
        return false
    }
    
    func getIndex(_ results: FetchedResults<Favorite>) -> Int? {
        let index = results.firstIndex {
            $0.gameID == gameID
        }
        return index
    }
}
