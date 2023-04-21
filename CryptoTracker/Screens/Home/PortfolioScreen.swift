//
//  PortfolioScreen.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/29/22.
//

import SwiftUI

struct PortfolioScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var vm: HomeScreenViewModel
    @Binding var portfolio: [CoinModel]
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                        
                    }
                }
                
                
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButtons
                }
            })
            .onChange(of: vm.searchText, perform: { value in
                if value == "" {
                    removeSelectedCoin()
                }
            })
        }
    }
}

struct PortfolioScreen_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioScreen(portfolio: .constant(dev.homeViewModel.user?.portfolio ?? []))
                    .environmentObject(dev.homeViewModel)
    }
}


extension PortfolioScreen {
    private var coinLogoList : some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHStack(spacing: 10) {
                ForEach(vm.allCoins) { coin in
                    CoinLogo(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            selectedCoin = coin
                            
                            
                        }
                        .background(RoundedRectangle(cornerRadius: 10).stroke(  selectedCoin?.id == coin.id ?  Color.theme.green : Color.clear, lineWidth: 1))
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        })
    }
    
    private func getCurrentValue () -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    
    
    private var portfolioInputSection : some View {
        VStack {
            HStack(spacing: 0) {
                Text("Current Price of \(selectedCoin?.symbol.uppercased() ?? "" ) : ")
                
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimal() ?? "" )
            }
            .padding(.vertical, 5)
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                
            }
            .padding(.vertical, 5)
            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimal())
            }
            .padding(.vertical, 5)
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    
    private var trailingNavBarButtons: some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Save".uppercased())
                    .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0)
            })
        }
    }

    private func saveButtonPressed() {
        guard let coin = selectedCoin, let amount = Double(quantityText) else {
            return
        }
        vm.updateCoinHoldings(coin: coin, amount: amount)
        withAnimation(.easeOut) {
            showCheckMark = true
            removeSelectedCoin()
        }
        // Hide Keyboard
        UIApplication.shared.endEditing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showCheckMark = false
        }
    }
    
    private func removeSelectedCoin () {
        selectedCoin = nil
        vm.searchText = ""
    }
}
