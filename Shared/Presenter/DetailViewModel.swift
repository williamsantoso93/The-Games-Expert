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
    @Published var isFavorite: Bool = false
    
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
            isLoading = true
            detailUseCase.addFavorite(game)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        self.isLoading = false
                    case .failure(let error):
                        self.message = "Error please try again"
                        print(error.localizedDescription)
                    }
                    self.getIsFavorite()
                }, receiveValue: { _ in
                })
                .store(in: &cancellables)
        }
    }
    
    func deleteFavorite(_ moc: NSManagedObjectContext, _ results: FetchedResults<Favorite>) {
        if let game = game {
            isLoading = true
            detailUseCase.deleteFavorite(game)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    self.isLoading = false
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.message = "Error please try again"
                        print(error.localizedDescription)
                    }
                    self.getIsFavorite()
                }, receiveValue: { _ in
                })
                .store(in: &cancellables)
        }
    }
    
    func getIsFavorite() {
        detailUseCase.getFavoriteList()
            .receive(on: RunLoop.main)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.message = "Error please try again"
                    print(error.localizedDescription)
                }
            } receiveValue: { data in
                self.isFavorite = self.isGameFavorite(data)
            }
            .store(in: &cancellables)
    }
    
    func isGameFavorite(_ gamesData: [GameData]) -> Bool {
        if getIndex(gamesData) != nil {
            return true
        }
        return false
    }
    
    func getIndex(_ gamesData: [GameData]) -> Int? {
        let index = gamesData.firstIndex {
            $0.gameID == gameID
        }
        return index
    }
}
