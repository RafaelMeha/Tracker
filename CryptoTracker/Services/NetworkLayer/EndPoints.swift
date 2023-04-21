//
//  EndPoints.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/25/22.
//

import Foundation


struct EndPoints {
    private static let api: String = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h"
    private static let marketData: String = "https://api.coingecko.com/api/v3/global"
    static var allCoins: URLRequest {
        let url: URL = URL(string: api)!
        return URLRequest(url: url)
    }
    
    
    static var getAllCoins: URL {
        return URL(string: api)!
    }
    
    static var getMarketData: URL {
        return URL(string: marketData)!
    }
//    static var getCointDetails: URL {
//        return URL(string: "https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")!
//    }
    
    static func coinDetails(id: String) -> URL {
        return URL(string: "https://api.coingecko.com/api/v3/coins/\(id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")!
    }
}
    
