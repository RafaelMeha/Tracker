//
//  Date.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 6/7/22.
//

import Foundation


extension Date{
    init(coinGeckoString: String) {
    let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinGeckoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter : DateFormatter{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func shortDateString() -> String {
        return shortFormatter.string(from: self )
    }
}
