//
//  ImageService.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/25/22.
//

import Foundation
import SwiftUI
import Combine



class ImageService {
    @Published var image: UIImage? = nil
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    private var coin: CoinModel
    private var imageSubscribtion: AnyCancellable?
//    Makes the network call for downloading the images
    private func getImage() {
        guard let url = URL(string: coin.image) else {
            return
        }
        NetworkService.get(url: url)
            .tryMap { (data) -> UIImage? in
                return  UIImage(data: data)
            }
            .sink(receiveCompletion: NetworkService.handleCompletion) { [weak self] (recievedImage) in
                guard let self = self , let downloadedImage = recievedImage else { return }
                self.image = recievedImage
                self.imageSubscribtion?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            }
        
        
    }
//    Init Method
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    
    
    
    func getCoinImage() {
        if let savedImage = fileManager.getImage(folderName: folderName, imageName: imageName) {
            image = savedImage
            print("Retrieved Image from File Successfully::: \(image.debugDescription)")
        }
        else {
            getImage()
        }
    }
}
