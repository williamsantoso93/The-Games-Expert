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
