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
    
    init(favoriteUseCase: FavoriteUseCase) {
        self.favoriteUseCase = favoriteUseCase
        loadList()
    }
    
    func loadList() {
        isLoading = true
        gamesData.removeAll()
        favoriteUseCase.getFavoriteList()
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
            }, receiveValue: { data in
                self.gamesData = data
            })
            .store(in: &cancellables)
    }
    
    func clearSearch() {
        searchText = ""
        loadList()
    }
    
    func linkBuilder<Content: View>(
      gameID: Int,
      @ViewBuilder content: () -> Content
    ) -> some View {
      NavigationLink(
      destination: router.makeDetailView(gameID: gameID)) { content() }
    }
}
