//
//  PortfolioDataService.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/29/22.
//

import Foundation
import CoreData
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class PortfolioDataService {
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    @Published var savedEntities : [PortfolioEntity] = []
    
    
    init() {
        container = NSPersistentContainer(name: containerName)
//       Loads Data from the container, and catches error
        container.loadPersistentStores { (_ , error) in
            if let error = error {
                print("Error Loading CoreData \(error)")
            }
            else{
//                Gets the contents for the Portfolio,  the CORE Data
                self.getPortfolio()
            }
        }
    }
    
//    MARK PUBLIC
    
    func updatePortfolio(coin: CoinModel, amount: Double)  {
        print("Incoming Data to be saved ->[Coin: \(coin.id)] && [Amount: \(amount) ] ")
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            }
            else {
             remove(entity: entity)
            }
        }
        
        else {
            add(coin: coin, amount: amount)
        }
    }
//    MARK PRIVATE
    private func getPortfolio() {
        guard let firebaseUser = Auth.auth().currentUser else {
            print("No user is currently signed in.")
            return
        }

        FirebaseManager.shared.fetchUser(userId: firebaseUser.uid) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.portfolio = user.portfolio
                }
            case .failure(let error):
                print("Error fetching user portfolio: \(error.localizedDescription)")
            }
        }
    }

    
    private func add(coin: CoinModel, amount: Double)  {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
        
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func remove(entity: PortfolioEntity){
        container.viewContext.delete(entity)
    }
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("The Error Saving to Porfolio Container : \(error)")
        }
    }
    
    private func applyChanges () {
        save()
        getPortfolio()
    }
}

