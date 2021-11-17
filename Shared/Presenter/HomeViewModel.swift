//
//  HomeViewModel.swift
//  
//
//  Created by William Santoso on 14/08/21.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var dataResult: DataResult?
    @Published var gamesData: [GameData] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var message = "No game data"
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        loadNewList()
    }
    
    func loadNewList() {
        gamesData.removeAll()
        getListGames()
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
    
    func clearSearch() {
        searchText = ""
        loadNewList()
    }
    
    func searchList() {
        if !searchText.isEmpty {
            loadNewList()
        }
    }
    
    func getListGames(nextPage: String? = nil) -> AnyPublisher<DataResult, NetworkError> {
        var queryItems: [URLQueryItem]? = []
        var urlString = ""
        if let nextPage = nextPage {
            urlString = nextPage
        } else {
            urlString = Networking.shared.baseAPI + "/games"
            if !searchText.isEmpty {
                queryItems?.append(.init(name: "search", value: searchText))
            }
        }
        isLoading = true
        return Future<DataResult, NetworkError> { completion in
            Networking.shared.getData(from: urlString, queryItems: queryItems)
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
    
    func loadMoreData(currentGamesData: GameData) {
        guard let next = dataResult?.next else { return }
        guard !gamesData.isEmpty else { return }
        let secondLastData = gamesData[gamesData.count - 2]
        if currentGamesData.gameID == secondLastData.gameID {
            getListGames(nextPage: next)
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
}
