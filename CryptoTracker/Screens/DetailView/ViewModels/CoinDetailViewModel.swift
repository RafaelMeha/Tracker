//
//  CoinDetailViewModel.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 6/6/22.
//

import Foundation
import Combine

class CoinDetailViewModel: ObservableObject {
    private let  coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable> ()
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    @Published var overviewStatistics: [StatisticsModel] = []
    @Published var additionalStatistics: [StatisticsModel] = [ ]
    @Published  var coin: CoinModel
 
    
    
    init(coin: CoinModel){
        self.coin = coin
        coinDetailService = CoinDetailDataService(coin: coin )
        addSubscribers()
    }
     
    
    //Combining CoinModel and CoinDetailModel
    //Then Mapping the Output
    private func addSubscribers( ) {
      coinDetailService.$coinDetail
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overView
                self?.additionalStatistics = returnedArrays.additional
         
        }
      .store(in: &cancellables)
        coinDetailService.$coinDetail.sink { [weak self] (returnedCoin) in
            self?.coinDescription = returnedCoin?.readableDescription
            self?.redditURL = returnedCoin?.links?.subredditURL
            self?.websiteURL = returnedCoin?.links?.homepage?.first
            
            
        }
        .store(in: &cancellables)
    }
    
    
    private func mapDataToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel ) -> (overView: [StatisticsModel], additional: [StatisticsModel]) {
        return (createOverviewArray(coinModel: coinModel) , createAdditionalArray(coinModel: coinModel, coinDetailModel: coinDetailModel))
    }
    
    private func createOverviewArray(coinModel: CoinModel) -> [StatisticsModel]{
        let price = coinModel.currentPrice.asCurrencyWith6Decimal()
        let priceChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticsModel(title: "Current Price", value: price,percentageChange: priceChange)
        let marketCap = " €" + ( coinModel.marketCap?.formattedWithAbbreviations() ?? "" )
        let marketCapChange = coinModel.marketCapChangePercentage24H
        let marketCapStats = StatisticsModel(title: "Market Capitalisation", value: marketCap, percentageChange: marketCapChange)
        let rank = "\(coinModel.rank)"
        let rakkStat = StatisticsModel(title: "Rank", value: rank)
        let totalVolume = " €" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "" )
        let volumeStat = StatisticsModel(title: "Volume", value: totalVolume)
        
        let overViewArray: [StatisticsModel] = [
        priceStat, marketCapStats, rakkStat, volumeStat
        ]
        return overViewArray
    }
    
    
    
    private func createAdditionalArray(coinModel: CoinModel, coinDetailModel: CoinDetailModel?) ->[StatisticsModel] {
        let high = coinModel.high24H?.asCurrencyWith6Decimal() ?? "n/a"
        let highStats = StatisticsModel(title: "24h High", value: high)
        let low = coinModel.low24H?.asCurrencyWith6Decimal() ?? "n/a"
        let lowStat = StatisticsModel(title: "24h Low", value: low)
        let priceChange2 = coinModel.priceChange24H?.asCurrencyWith6Decimal() ?? ""
        let pricePercentChange2 = coinModel.priceChangePercentage24H
        let priceStats = StatisticsModel(title: "24h Price Change", value: priceChange2 , percentageChange: pricePercentChange2)
        let marketCapChange2 = coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? ""
        let marketCapPercentageChange2 = coinModel.marketCapChangePercentage24H
        let marketStats2 = StatisticsModel(title: "Market Cap", value: marketCapChange2, percentageChange: marketCapPercentageChange2 )
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ?  "n/a" : "\(blockTime)"
        let blockStats = StatisticsModel(title: "Block Time", value: blockTimeString)
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticsModel(title: "Hashing Algorithm", value: hashing)
        let additionalArray: [StatisticsModel] = [
        highStats, lowStat,priceStats ,marketStats2, blockStats, hashingStat
        ]
        return additionalArray

    }
}
