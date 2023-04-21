//
//  CoinLogo.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/29/22.
//

import SwiftUI

struct CoinLogo: View {
    let coin: CoinModel
    var body: some View {
        VStack{
            BuildCoinImage(coinModel: coin)
                .frame(width: 50, height: 50)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            
            Text(coin.name)
                .foregroundColor(Color.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
            
        }
    }
}

struct CoinLogo_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinLogo(coin: dev.coin)
                .previewLayout(.sizeThatFits)
            CoinLogo(coin: dev.coin)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)

        }
    }
}
