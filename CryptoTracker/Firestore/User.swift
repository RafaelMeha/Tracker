//
//  User.swift
//  CryptoTracker
//
//  Created by Rafael Meha on 21/04/2023.
//

struct User: Identifiable, Codable {
    let id: String
    var email: String
    var portfolio: [CoinModel]
}
