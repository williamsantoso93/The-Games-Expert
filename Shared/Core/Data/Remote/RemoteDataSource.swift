//
//  RemoteDataSource.swift
//  The Games (iOS)
//
//  Created by iOS Dev on 11/18/21.
//

import Foundation
import Alamofire
import Combine

enum NetworkError: Error {
    case badUrl
    case decodingError
    case encodingError
    case noData
    case notLogin
    case errorMessage(String)
    case statusCode(Int)
}

protocol RemoteDataSourceProtocol {
    func getListGames(nextPage: String?, searchText: String) -> AnyPublisher<DataResult, NetworkError>
    func getDetail(_ gameID: Int) -> AnyPublisher<DetailGame, NetworkError>
}

final class RemoteDataSource: NSObject {
    
    private override init() { }
    
    static let sharedInstance = RemoteDataSource()
    
    let baseAPI = "https://api.rawg.io/api"
    let apiKey = "e07d0723795c4dfc8130cbcaf6083be6"
}

extension RemoteDataSource: RemoteDataSourceProtocol {
    func getListGames(nextPage: String? = nil, searchText: String) -> AnyPublisher<DataResult, NetworkError> {
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
        var components = URLComponents(string: urlString)!
        components.queryItems = []
        if let queryItems = queryItems {
            components.queryItems = queryItems
        }
        components.queryItems?.append(URLQueryItem(name: "key", value: apiKey))
        return Future<DataResult, NetworkError> { completion in
            if let url = components.url {
                AF.request(url).validate().responseDecodable(of: DataResult.self) { response in
                    switch response.result {
                    case .success(let value):
                        completion(.success(value))
                    case .failure:
                        completion(.failure(.decodingError))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getDetail(_ gameID: Int) -> AnyPublisher<DetailGame, NetworkError> {
        let urlString = Networking.shared.baseAPI + "/games/\(gameID)"
        var components = URLComponents(string: urlString)!
        components.queryItems = []
        components.queryItems?.append(URLQueryItem(name: "key", value: apiKey))
        return Future<DetailGame, NetworkError> { completion in
            if let url = components.url {
                AF.request(url).validate().responseDecodable(of: DetailGame.self) { response in
                    switch response.result {
                    case .success(let value):
                        completion(.success(value))
                    case .failure:
                        completion(.failure(.decodingError))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
