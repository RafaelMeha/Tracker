//
//  MarketDataService.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/27/22.
//

import Foundation

import Combine

class MarketDataService {
    @Published var marketData: MarketDataModel? = nil
    var cancellable = Set<AnyCancellable>()
    var marketDataSubscription: AnyCancellable?
    
    
    
    init() {
        getMarketData()
    }
    
    
    public  func getMarketData() {
        marketDataSubscription =  NetworkService.get(url: EndPoints.getMarketData)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkService.handleCompletion, receiveValue: { [weak self] ( returnedGlobalData) in
                guard let self = self else { return }
                self.marketData = returnedGlobalData.data
                self.marketDataSubscription?.cancel()
            })
    }
}
