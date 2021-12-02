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
    
    @Published var dataResult: GamesListResponse?
    @Published var gamesData: [GameData] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var message = "No game data"
    
    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
        loadNewList()
    }
    
    func getListGames(nextPage: String? = nil) {
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
                    let mappedResults = GameMapper.mapGameDataResponsesToGamedata(input: results)
                    self.gamesData.append(contentsOf: mappedResults)
                    if self.gamesData.isEmpty {
                        self.message = "no game data"
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    func loadNewList() {
        isLoading = true
        gamesData.removeAll()
        getListGames()
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
            getListGames(nextPage: next)
        }
    }
    
    func linkBuilder<Content: View>(
      gameID: Int,
      @ViewBuilder content: () -> Content
    ) -> some View {
      NavigationLink(
      destination: router.makeDetailView(gameID: gameID)) { content() }
    }
    
    func linkBuilderFavorite<Content: View>(
      @ViewBuilder content: () -> Content
    ) -> some View {
      NavigationLink(
      destination: router.makeFavoriteView()) { content() }
    }
}
