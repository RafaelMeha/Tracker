//
//  SearchBarView.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/26/22.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ?  Color.theme.secondaryText : Color.theme.accent )
            TextField("Search by name or symbol... ", text: $searchText)
                .overlay(Image(systemName: "xmark.circle.fill")
                            .padding()
                            .offset(x: 10)
                            .foregroundColor(Color.theme.accent)
                            .disableAutocorrection(true)
                            .opacity(searchText.isEmpty ? 0.0 : 1.0)
                         , alignment: .trailing)
                .onTapGesture{
                    UIApplication.shared.endEditing()
                    searchText = ""
                }
            
            
        }
        .font(.headline)
        .padding()
        .background(RoundedRectangle(cornerRadius: 25).fill(Color.theme.background)
                        .shadow(color: Color.theme.accent.opacity(0.15), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/))
        .padding()
        
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
            .preferredColorScheme(.light)
    }
}
