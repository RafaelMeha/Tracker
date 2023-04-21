//
//  DetailsView.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 5/30/22.
//

import SwiftUI


struct DetailLoadingView: View {
    @Binding var coin:CoinModel?
    var body: some View {
        ZStack {
            if let coin = coin  {
                DetailsView(coin: coin)
            }
        }
    }
}


struct DetailsView: View {
    
    @StateObject private  var vm: CoinDetailViewModel
    @State var showFullDescription : Bool = false
    private  let spacing:CGFloat = 30
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    init(coin: CoinModel){
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
        print("Initialising Detail View for \(coin.name)")
    }
     
    var body: some View {
        ScrollView{
            
            VStack{
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing: 20){
                  
                  overview
                    Divider()
                   descriptionSection
                   overviewGrid
                   additionalTitle
                    Divider()
                   additionalGrid
                    
                  websiteSection
                }
                .padding()
            }
           
            
        }
        .navigationBarTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
             
                   
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailsView(coin: dev.coin)
//
        }
    }
}





extension DetailsView{
    
    private var navigationBarTrailingItems: some View{
        HStack{
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            BuildCoinImage(coinModel: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    private var overview: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View{
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View{
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  
                  content: {
//
            ForEach(vm.overviewStatistics) { stat in
                StatisticsView(stat: StatisticsModel(title: stat.title, value: stat.value, percentageChange: stat.percentageChange))
            }
        })
    }
    
    
    private var additionalGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  
                  content: {
//
            ForEach(vm.additionalStatistics) { stat in
                StatisticsView(stat: StatisticsModel(title: stat.title, value: stat.value,percentageChange: stat.percentageChange))
            }
        })
    }
    
    
    private var descriptionSection : some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack (alignment: .leading) {
                    Text(coinDescription )
                        .lineLimit(showFullDescription ? nil : 3)
                        .foregroundColor(Color.theme.secondaryText)
                        .font(.callout )
                
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text( showFullDescription ?  "Less.." : "Read More..")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .accentColor(Color.blue)

                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
    }
    
    private var websiteSection: some View {
        VStack(alignment : .leading, spacing: 10) {
                if let website = vm.websiteURL , let webURL = URL(string: website) {
                     Link("Website", destination: webURL)
                }
                if let reddit = vm.redditURL , let redditURL = URL(string: reddit) {
                     Link("Reddit", destination: redditURL)
                }
            }
        
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
