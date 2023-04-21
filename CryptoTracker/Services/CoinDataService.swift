//
//  CoinDataService.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/25/22.
//

import Foundation
import Combine

class CoinDataService {
    
    var cancellable = Set<AnyCancellable>()
    var coinSubscription: AnyCancellable?
    
    @Published var allCoins: [CoinModel] = []
    
    init() {
        getAllCoins()
    }
    
    
    public  func getAllCoins() {
        coinSubscription =  NetworkService.get(url: EndPoints.getAllCoins)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkService.handleCompletion, receiveValue: { [weak self] ( returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
    }
}
