//
//  HomeScreenViewModel.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/25/22.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class HomeScreenViewModel: ObservableObject {
    @Published var statistics: [StatisticsModel] = []
    
    private var authViewModel = AuthViewModel()
    
    @Published var user: User?

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    private let portfolioDataService = PortfolioDataService()
    @Published var  allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .price
    enum SortOption {
    case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
}
//    The Init method to be called, when the class is being initialised.
    init() {
        addSubscribers()
        
        authViewModel.$signedIn
            .sink { signedIn in
                print("User signed in status: \(signedIn)")
            }
            .store(in: &cancellables)
        
        if let firebaseUser = Auth.auth().currentUser {
            // Fetch user data from Firestore
            FirebaseManager.shared.getUser(userId: firebaseUser.uid) { [weak self] result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self?.user = user
                    }
                case .failure(let error):
                    print("Error fetching user data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    func updateCoinHoldings(coin: CoinModel, amount: Double) {
        // Update the portfolio in the user object
        if let index = user?.portfolio.firstIndex(where: { $0.id == coin.id }) {
            user?.portfolio[index].currentHoldings = amount
        } else {
            var updatedCoin = coin
            updatedCoin.currentHoldings = amount
            user?.portfolio.append(updatedCoin)
        }

        // Save the updated user object to Firestore
        if let updatedUser = user {
            FirebaseManager.shared.saveUser(updatedUser) { result in
                switch result {
                case .success():
                    print("User's portfolio successfully updated.")
                case .failure(let error):
                    print("Error updating user's portfolio: \(error.localizedDescription)")
                }
            }
        }
    }

    

    
    
    func addSubscribers() {
        //returns queried coins, after 0.5 second
        $searchText.combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSort)
            .sink { [weak self] (recivedValue) in
                self?.allCoins = recivedValue
            }
            .store(in: &cancellables)
//        Update PortfolioCoins
        $allCoins.combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self  = self else{ return }
                self.portfolioCoins = self.sortPortfolioIfNeeded(coins: returnedCoins)
                print("Portfolio Coins are : \(String(describing: self.portfolioCoins.count))")
            }
            .store(in: &cancellables)
//         Get Global Market Data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getAllCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
     
    }
    
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
//   checked
   private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings : return coins.sort(by: {$0.rank < $1.rank})
        case .rankReversed, .holdingsReversed : return coins.sort(by: {$0.rank > $1.rank})
        case .price: return coins.sort(by: {$0.currentPrice  > $1.currentPrice } )
        case .priceReversed: return coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    private func filterAndSort(text: String , coins: [CoinModel], sort: SortOption) -> [CoinModel]  {
        var updatedCoins = filterCoins(text: text, coins: coins)
       sortCoins(sort: sort , coins: &updatedCoins)
        return updatedCoins
    }
 private   func filterCoins(text: String , coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        let lowerCased = text.lowercased()
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowerCased) || coin.symbol.lowercased().contains(lowerCased) || coin.id.lowercased().contains(lowerCased)
        }
    }
    func sortPortfolioIfNeeded(coins: [CoinModel]) -> [CoinModel] {
//        We will only sort by Holdings and reverse holdings if needed
        switch sortOption {
        case .holdings:
            return coins.sorted(by: ({$0.currentHoldingsValue > $1.currentHoldingsValue }))
        case .holdingsReversed:
            return coins.sorted(by: ({$0.currentHoldingsValue < $1.currentHoldingsValue }))
        default: return coins
        }
    }
    func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel] , portfolioCoins: [PortfolioEntity]) -> [CoinModel] {
        allCoins.compactMap { (coin) -> CoinModel? in
            guard let entity = portfolioCoins.first(where: { $0.coinID == coin.id}) else { return nil}
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private  func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticsModel] {
    var stats: [StatisticsModel] = []
    guard let data = marketDataModel else{
        return stats
    }
//        Adds up all the value of the portfolio coins
    let portfolioValue  = portfolioCoins.map( { $0.currentHoldingsValue })
            .reduce(0, + )
        let prevValue = portfolioCoins.map { (coin) -> Double in
            let currentVal = coin.currentHoldingsValue
            let percentageChange = (coin.priceChangePercentage24H ?? 0) / 100
            let  prevValue = currentVal / (1 + percentageChange)
            return prevValue
        }
            .reduce(0, +)
        let percentageChange = ( (portfolioValue - prevValue) / prevValue) * 100
    let marketCap = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HEur)
    let volume = StatisticsModel(title: "24h Volume", value: data.volume)
    let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticsModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimal(), percentageChange: percentageChange)
       
    stats.append(contentsOf: [
        marketCap,
        volume,
        btcDominance,
        portfolio
        
    ])
    return stats
    }
}


