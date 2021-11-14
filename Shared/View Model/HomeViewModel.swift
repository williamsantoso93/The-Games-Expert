//
//  HomeViewModel.swift
//  
//
//  Created by William Santoso on 14/08/21.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var dataResult: DataResult?
    @Published var gamesData: [GameData] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var message = "No game data"
    
    init() {
        loadNewList()
    }
    
    func loadNewList() {
        gamesData.removeAll()
        getListGames { (result: Result<DataResult, Error>) in
            switch result {
            case .success(let data) :
                self.dataResult = data
                if let results = data.results {
                    self.gamesData = results
                    if self.gamesData.isEmpty {
                        self.message = "no game data"
                    }
                }
            case .failure(_) :
                self.message = "Error please try again"
            }
        }
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
    
    func getListGames(nextPage: String? = nil, completion: @escaping (Result<DataResult, Error>) -> Void) {
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
        guard !urlString.isEmpty else { return }
        Networking.shared.getData(from: urlString, queryItems: queryItems) { (result: Result<DataResult, NetworkError>, _) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data) :
                    completion(.success(data))
                case .failure(let error) :
                    completion(.failure(error))
                }
            }
        }
    }
    
    func loadMoreData(currentGamesData: GameData) {
        guard let next = dataResult?.next else { return }
        guard !gamesData.isEmpty else { return }
        let secondLastData = gamesData[gamesData.count - 2]
        if currentGamesData.gameID == secondLastData.gameID {
            getListGames(nextPage: next) { (result: Result<DataResult, Error>) in
                switch result {
                case .success(let data) :
                    self.dataResult = data
                    if let results = data.results {
                        self.gamesData.append(contentsOf: results)
                        if self.gamesData.isEmpty {
                            self.message = "no game data"
                        }
                    }
                case .failure(_) :
                    self.message = "Error please try again"
                }
            }
        }
    }
}
