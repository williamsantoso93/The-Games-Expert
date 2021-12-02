//
//  Extension.swift
//  The Games
//
//  Created by William Santoso on 14/08/21.
//

import Foundation

extension Data {
    func jsonToString() -> String {
        return String(data: self, encoding: .utf8) ?? "error encoding"
    }
}

extension Date {
    func dateToStringLong() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long        
        return dateFormatter.string(from: self)
    }
}

enum URLError: LocalizedError {
    case invalidResponse
    case addressUnreachable(URL)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "The server responded with garbage."
        case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
        }
    }
}

enum DatabaseError: LocalizedError {
    case invalidInstance
    case requestFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidInstance: return "Database can't instance."
        case .requestFailed: return "Your request failed."
        }
    }
}
