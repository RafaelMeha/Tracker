//
//  CoinDetailDataService.swift
//  CryptoTracker
//

//

import Foundation
import Combine

class CoinDetailDataService {
    
    var cancellable = Set<AnyCancellable>()
    var coinDetailSubscription: AnyCancellable?
    let coin:CoinModel
    
    @Published var coinDetail: CoinDetailModel? = nil
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
    
    public  func getCoinDetails() {
        coinDetailSubscription =  NetworkService.get(url: EndPoints.coinDetails(id: coin.id))
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkService.handleCompletion, receiveValue: { [weak self] ( returnedCoinDetail) in
                self?.coinDetail = returnedCoinDetail
                self?.coinDetailSubscription?.cancel()
            })
    }
}

