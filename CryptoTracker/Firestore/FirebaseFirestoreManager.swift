//
//  FirebaseFirestoreManager.swift
//  CryptoTracker
//
//  Created by Rafael Meha on 21/04/2023.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseFirestoreManager {
    static let shared = FirebaseFirestoreManager()
    private let db = Firestore.firestore()

    // Your other Firestore-related functions here

    func createUser(userId: String, email: String, completion: @escaping (Error?) -> Void) {
        let userRef = db.collection("users").document(userId)
        let user = User(id: userId, email: email, portfolio: [])

        do {
            try userRef.setData(from: user) { error in
                completion(error)
            }
        } catch let error {
            completion(error)
        }
    }
    
    func fetchUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        let userRef = db.collection("users").document(userId)

        userRef.getDocument { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documentSnapshot = documentSnapshot else {
                completion(.failure(NSError(domain: "FirebaseManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document not found"])))
                return
            }

            do {
                if let user = try documentSnapshot.data(as: User.self) {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "FirebaseManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user data"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}

