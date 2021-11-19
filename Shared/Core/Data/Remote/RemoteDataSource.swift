//
//  RemoteDataSource.swift
//  The Games (iOS)
//
//  Created by iOS Dev on 11/18/21.
//

import Foundation
import Alamofire
import Combine

protocol RemoteDataSourceProtocol {
    func getListGames(nextPage: String?, searchText: String) -> AnyPublisher<GamesListResponse, Error>
    func getDetail(_ gameID: Int) -> AnyPublisher<DetailGameResponse, Error>
}

final class RemoteDataSource: NSObject {
    
    private override init() { }
    
    static let sharedInstance = RemoteDataSource()
    
    let baseAPI = "https://api.rawg.io/api"
    let apiKey = "e07d0723795c4dfc8130cbcaf6083be6"
}

extension RemoteDataSource: RemoteDataSourceProtocol {
    func getListGames(nextPage: String? = nil, searchText: String) -> AnyPublisher<GamesListResponse, Error> {
        var queryItems: [URLQueryItem]? = []
        var urlString = ""
        if let nextPage = nextPage {
            urlString = nextPage
        } else {
            urlString = baseAPI + "/games"
            if !searchText.isEmpty {
                queryItems?.append(.init(name: "search", value: searchText))
            }
        }
        var components = URLComponents(string: urlString)!
        components.queryItems = []
        if let queryItems = queryItems {
            components.queryItems = queryItems
        }
        components.queryItems?.append(URLQueryItem(name: "key", value: apiKey))
        return Future<GamesListResponse, Error> { completion in
            if let url = components.url {
                AF.request(url).validate().responseDecodable(of: GamesListResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        completion(.success(value))
                    case .failure:
                        completion(.failure(URLError.invalidResponse))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getDetail(_ gameID: Int) -> AnyPublisher<DetailGameResponse, Error> {
        let urlString = baseAPI + "/games/\(gameID)"
        var components = URLComponents(string: urlString)!
        components.queryItems = []
        components.queryItems?.append(URLQueryItem(name: "key", value: apiKey))
        return Future<DetailGameResponse, Error> { completion in
            if let url = components.url {
                AF.request(url).validate().responseDecodable(of: DetailGameResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        completion(.success(value))
                    case .failure:
                        completion(.failure(URLError.invalidResponse))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
