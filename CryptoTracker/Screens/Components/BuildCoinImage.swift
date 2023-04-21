//
//  BuildCoinImage.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/25/22.
//

import SwiftUI

struct BuildCoinImage: View {
    @StateObject var vm: BuildCoinImageViewModel
    init(coinModel : CoinModel) {
        _vm = StateObject(wrappedValue: BuildCoinImageViewModel(coin: coinModel ))
    }
    var body: some View {
        ZStack{
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            else if vm.isLoading {
                ProgressView()
            }
            else {
                Image(systemName: "questionmark")
                
            }
            
            
        }
    }
}

struct BuildCoinImage_Previews: PreviewProvider {
    static var previews: some View {
        BuildCoinImage(coinModel: dev.coin)
        
    }
}



