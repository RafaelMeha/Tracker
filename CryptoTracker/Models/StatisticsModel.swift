//
//  StatisticsModel.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/26/22.
//

import Foundation



struct StatisticsModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String , value: String  , percentageChange : Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
