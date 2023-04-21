//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 6/28/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    let deafultURL  = URL(string: "https://www.google.com")!
    let personalURL  = URL(string: "https://www.google.com")!
    let youtubURL  = URL(string: "https://www.google.com")!
    let githubURL  = URL(string: "https://www.google.com")!
    let twitterURL  = URL(string: "https://www.twitter.com/_Collins01")!
    let coffeeURL = URL(string: "https://www.twitter.com/_Collins01")!
    let coinGeckoURL = URL(string: "https://www.twitter.com/_Collins01")!
    var body: some View {
        NavigationView{
            
            List{
            Button(action: {
                authViewModel.signOut()
            }, label: {
                Text("Log Out")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.gray)
                    .cornerRadius(8)
            })
            socialInfoSection
            coinGeckoInfoSection
            developerDescriptionSection
            applicationSection
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                       XMarkButton()
                    }

                }
            }
           
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AuthViewModel())
    }
}


extension SettingsView {
    private var socialInfoSection: some View {
        Section(header: Text("Collins01"), footer: Text("Footer"), content: {
            VStack{
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
            }
            Text("This app was made by following a course by @SwiftfulThinking on Youtube. It uses Combine, Core-Data, and the MVVM architecture design.")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(Color.theme.accent)
            Link("Github 💻", destination: githubURL)
            Link("Twitter 🐣", destination: twitterURL)
            Link("Youtube 🎬", destination: youtubURL)
            Link("Coffee ☕️", destination: coffeeURL)
            
        } )
        .accentColor(.blue)
    }
    private var coinGeckoInfoSection: some View {
        Section(header: Text("CoinGecko"), footer: Text("Footer"), content: {
            VStack{
                Image("coingecko")
                    .resizable()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
            }
            Text("The cryptocurrency API used in this project, comes from CoinGecko!. Prices may be slightly delayed.")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(Color.theme.accent)
            Link("CoinGecko 🕸", destination: coinGeckoURL)
        
            
        } )
        .accentColor(.blue)
    }
    
    private var developerDescriptionSection: some View {
        Section(header: Text("CoinGecko"), footer: Text(""), content: {
            VStack{
                Image("logo")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
            }
            Text("This App was develped by Oriakhi Collins. It uses SwiftUI, and is written in 100% Swift Language. The project benefits from ulti-threading, publisher/subscribers, and data persistence using Core-Data.")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(Color.theme.accent)
            Link("Visit Website 🕸", destination: personalURL )
        
            
        } )
        .accentColor(.blue)
    }
    
    private var applicationSection: some View {
        Section(header: Text("Application"), footer: Text(""), content: {

            Link("Terms of Service", destination: coinGeckoURL)
            Link("Privacy Policy", destination: coinGeckoURL)
            Link("Company Website", destination: coinGeckoURL)
            Link("Learn More", destination: coinGeckoURL)
        } )
        .accentColor(.blue)
    }
    
}
