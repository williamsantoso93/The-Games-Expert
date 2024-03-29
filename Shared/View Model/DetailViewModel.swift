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
    @Published var game: DetailGame?
    @Published var gameID: Int?
    @Published var isLoading = false
    @Published var message = "Error please try again"
    private var cancellables: Set<AnyCancellable> = []
    
    func getGameDetail() {
        guard let gameID = gameID else { return }
        isLoading = true
        let urlString = Networking.shared.baseAPI + "/games/\(gameID)"
        getDetail(urlString)
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
    
    func getDetail(_ urlString: String) -> AnyPublisher<DetailGame, NetworkError> {
        return Future<DetailGame, NetworkError> { completion in
            Networking.shared.getData(from: urlString)
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
                    completion(.success(data))
                })
                .store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
    
    func addFavorite(_ moc: NSManagedObjectContext) {
        if let game = game {
            let favorite = Favorite(context: moc)
            favorite.favoriteID = UUID()
            favorite.timestamp = Date()
            favorite.gameID = Int64(game.detailID)
            favorite.name = game.name
            favorite.rating = game.rating ?? 0
            favorite.backgroundImage = game.backgroundImage
            favorite.released = game.released
            if let genresData = try? JSONEncoder().encode(game.genres) {
                favorite.genres = String(data: genresData, encoding: .utf8)
            }
            PersistenceController.shared.save()
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
        if let gameID = gameID {
            let index = results.firstIndex {
                $0.gameID == gameID
            }
            return index
        }
        return nil
    }
}
