//
//  SignUpView.swift
//  CryptoTracker
//
//  Created by Rafael Meha on 19/04/2023.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var registrationComplete = false
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            SecureField("Password", text: $password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        
            Button(action: {
                authViewModel.signUp(email: email, password: password)
            }, label: {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            })
            .alert(isPresented: $registrationComplete) {
                Alert(
                    title: Text("Welcome!"),
                    message: Text("You have successfully registered."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AuthViewModel())
    }
}
