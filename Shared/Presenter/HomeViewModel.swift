//
//  HomeViewModel.swift
//  
//
//  Created by William Santoso on 14/08/21.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let router = HomeRouter()
    private let homeUseCase: HomeUseCase
    
    @Published var dataResult: DataResult?
    @Published var gamesData: [GameData] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var message = "No game data"
    
    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
        loadNewList()
    }
    
    func loadNewList() {
        isLoading = true
        gamesData.removeAll()
        homeUseCase.getListGames(nextPage: nil, searchText: self.searchText)
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
                self.dataResult = data
                if let results = data.results {
                    self.gamesData.append(contentsOf: results)
                    if self.gamesData.isEmpty {
                        self.message = "no game data"
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    func clearSearch() {
        searchText = ""
        loadNewList()
    }
    
    func searchList() {
        if !searchText.isEmpty {
            loadNewList()
        }
    }
    
    func loadMoreData(currentGamesData: GameData) {
        guard let next = dataResult?.next else { return }
        guard !gamesData.isEmpty && gamesData.count >= 2 else { return }
        let secondLastData = gamesData[gamesData.count - 2]
        if currentGamesData.gameID == secondLastData.gameID {
            homeUseCase.getListGames(nextPage: next, searchText: self.searchText)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.message = "Error please try again"
                        print(error.localizedDescription)
                    }
                }, receiveValue: { data in
                    self.dataResult = data
                    if let results = data.results {
                        self.gamesData.append(contentsOf: results)
                        if self.gamesData.isEmpty {
                            self.message = "no game data"
                        }
                    }
                })
                .store(in: &cancellables)
        }
    }
    func linkBuilder<Content: View>(
      gameID: Int,
      @ViewBuilder content: () -> Content
    ) -> some View {
      NavigationLink(
      destination: router.makeDetailView(gameID: gameID)) { content() }
    }
    func linkFavoriteBuilder<Content: View>(@ViewBuilder content: () -> Content) -> some View {
      NavigationLink(
        destination: router.makeFavoriteView()) { content() }
    }
}
