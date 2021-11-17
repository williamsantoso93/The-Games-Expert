//
//  Networking.swift
//  The Games
//
//  Created by William Santoso on 12/08/21.
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

protocol NetworkingProtocol {
    func getData<T: Codable>(from urlString: String, queryItems: [URLQueryItem]?) -> AnyPublisher<T, NetworkError>
}

class Networking: NetworkingProtocol {
    static let shared = Networking()
    let baseAPI = "https://api.rawg.io/api"
    let apiKey = "e07d0723795c4dfc8130cbcaf6083be6"
    
    func getData<T: Codable> (from urlString: String, queryItems: [URLQueryItem]? = nil) -> AnyPublisher<T, NetworkError> {
        var components = URLComponents(string: urlString)!
        components.queryItems = []
        if let queryItems = queryItems {
            components.queryItems = queryItems
        }
        components.queryItems?.append(URLQueryItem(name: "key", value: apiKey))        
        return Future<T, NetworkError> { completion in
            if let url = components.url {
                AF.request(url).validate().responseDecodable(of: T.self) { response in
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
