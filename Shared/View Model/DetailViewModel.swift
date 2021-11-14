//
//  DetailViewModel.swift
//  The Games
//
//  Created by William Santoso on 15/08/21.
//

import SwiftUI
import CoreData

class DetailViewModel: ObservableObject {
    @Published var game: DetailGame?
    @Published var gameID: Int?
    @Published var isLoading = false
    @Published var message = "Error please try again"
    func getGameDetail() {
        guard let gameID = gameID else { return }
        isLoading = true
        let urlString = Networking.shared.baseAPI + "/games/\(gameID)"
        Networking.shared.getData(from: urlString) { (result: Result<DetailGame, NetworkError>, _) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data) :
                    self.game = data
                case .failure(_) :
                    self.message = "Error please try again"
                }
            }
        }
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
