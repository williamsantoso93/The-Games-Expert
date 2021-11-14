//
//  Networking.swift
//  The Games
//
//  Created by William Santoso on 12/08/21.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case badUrl
    case decodingError
    case encodingError
    case noData
    case notLogin
    case errorMessage(String)
    case statusCode(Int)
}

class Networking {
    static let shared = Networking()
    let baseAPI = "https://api.rawg.io/api"
    let apiKey = "e07d0723795c4dfc8130cbcaf6083be6"
    
    func getData<T: Codable> (from urlString: String, queryItems: [URLQueryItem]? = nil, completion: @escaping ((Result<T, NetworkError>), URLResponse?) -> Void) {
        var components = URLComponents(string: urlString)!
        components.queryItems = []
        if let queryItems = queryItems {
            components.queryItems = queryItems
        }
        components.queryItems?.append(URLQueryItem(name: "key", value: apiKey))
        guard let url = components.url else {
            return completion(.failure(.badUrl), nil)
        }
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard let data = data, error == nil else {
//                return completion(.failure(.noData), response)
//            }
//            guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
//                return completion(.failure(.errorMessage(data.jsonToString())), response)
//            }
//            completion(.success(decoded), response)
//        }.resume()
        AF.request(url).validate().responseDecodable(of: T.self) { response in
            switch response.result {
                case .success(let value):
                    completion(.success(value), response.response)
                case .failure:
                    completion(.failure(.decodingError), nil)
            }
        }
    }
}
