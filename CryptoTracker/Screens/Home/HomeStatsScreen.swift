//
//  HomeStatsScreen.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/27/22.
//

import SwiftUI

struct HomeStatsScreen: View {
    @Binding var showPortfolio: Bool
    @EnvironmentObject private var vm: HomeScreenViewModel
    
    var body: some View {
        HStack{
            ForEach(vm.statistics) { stat in
                StatisticsView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width , alignment: showPortfolio ? .trailing :  .leading)
    }
}

struct HomeStatsScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsScreen(showPortfolio: .constant(false))
            .environmentObject(dev.homeViewModel)
    }
}
