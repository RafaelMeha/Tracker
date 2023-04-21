//
//  AuthViewModel.swift
//  CryptoTracker
//
//  Created by Rafael Meha on 19/04/2023.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var signedIn = false
    @Published var registrationComplete = false

    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        // Listen for authentication state changes
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            self?.signedIn = user != nil
        }
    }

    deinit {
        // Remove the listener when the object is deallocated
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard error == nil, let _ = result?.user else {
                print("Error signing in: \(String(describing: error))")
                return
            }
            self?.signedIn = true
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard error == nil, let user = result?.user else {
                print("Error signing up: \(String(describing: error))")
                return
            }
            self?.signedIn = true
            self?.registrationComplete = true

            // Create a user document in Firestore after successful registration
            FirebaseFirestoreManager.shared.createUser(userId: user.uid, email: email) { error in
                if let error = error {
                    print("Error creating user document: \(error)")
                } else {
                    print("User document created successfully")
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.signedIn = false
        } catch let error {
            print("Error signing out: \(error)")
        }
    }

}
