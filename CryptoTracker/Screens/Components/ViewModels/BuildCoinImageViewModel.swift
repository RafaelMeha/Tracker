//
//  BuildCoinImageViewModel.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/25/22.
//

import Foundation
import SwiftUI
import Combine
class BuildCoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = true
    private var cancellables = Set<AnyCancellable>()
    var imageService: ImageService
    let coin: CoinModel
    private func getCoinImage() {
        
    }
    init(coin: CoinModel) {
        self.imageService = ImageService(coin: coin)
        self.coin = coin
        self.addSubscribers()
    }
    
    
    func addSubscribers() {
        imageService.$image.sink { (_) in
            self.isLoading = false
        } receiveValue: {[weak self] (recivedImage) in
            self?.image = recivedImage
        }
        .store(in: &cancellables)

    }
}
