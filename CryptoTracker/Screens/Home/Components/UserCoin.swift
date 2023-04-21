//
//  UserCoin.swift
//  CryptoTracker
//
//  Created by Rafael Meha on 19/04/2023.
//

import Foundation

struct Portfolio: Codable, Identifiable {
    let id: String
    let userId: String
    var coins: [CoinModel]

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case coins
    }
}
