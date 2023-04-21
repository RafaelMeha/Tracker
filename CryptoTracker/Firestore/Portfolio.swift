//
//  Portfolio.swift
//  CryptoTracker
//
//  Created by Rafael Meha on 19/04/2023.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseManager {
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()

    private init() {}

    func getUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        let docRef = db.collection("users").document(userId)
        docRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let document = document, document.exists, let user = try? document.data(as: User.self) {
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        }
    }

    func saveUser(_ user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection("users").document(user.id).setData(from: user)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
}
