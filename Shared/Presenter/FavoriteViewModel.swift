//
//  FavoriteViewModel.swift
//  The Games (iOS)
//
//  Created by iOS Dev on 11/19/21.
//

import SwiftUI
import Combine

class FavoriteViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let router = HomeRouter()
    private let favoriteUseCase: FavoriteUseCase
    
    @Published var gamesData: [GameData] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var message = "No game data"
    
    var filterGamesData: [GameData] {
        if searchText.isEmpty {
            return gamesData
        }
        return gamesData.filter {
            $0.name.localizedStandardContains(searchText.lowercased())
        }
    }
    
    init(favoriteUseCase: FavoriteUseCase) {
        self.favoriteUseCase = favoriteUseCase
        loadNewList()
    }
    
    func loadNewList() {
        isLoading = true
        favoriteUseCase.getListGames()
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
                self.gamesData = data
            }
            .store(in: &cancellables)
    }
    
    func linkBuilder<Content: View>(
      gameID: Int,
      @ViewBuilder content: () -> Content
    ) -> some View {
      NavigationLink(
      destination: router.makeDetailView(gameID: gameID)) { content() }
    }
}
