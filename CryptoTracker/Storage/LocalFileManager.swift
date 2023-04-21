//
//  LocalFileManager.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/26/22.
//

import Foundation
import SwiftUI
class LocalFileManager {
//    private let  folderName: String = "coin_images"
    //    Creates an instance of the class
    static let instance = LocalFileManager()
    init() { }
    
    
    func saveImage(image: UIImage, imageName: String , folderName: String) {
        createFolderIfNeeeded(folderName: folderName)
        guard let data = image.pngData(), let url = getURLForImage(imageName: imageName, folderName: folderName) else {
            return
        }
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving Image (\(imageName) was  : \(error)")
        }
        
    }
    
    
//    Creates a folder if needed
    private func createFolderIfNeeeded (folderName: String ) {
//        Checks if the Folder Exists. if it does not, create a new folder with the `folder name`
        guard let url = getUrlForFolder(folderName: folderName) else {
            return
        }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error  {
                print("The Error that occured while trying to Create Folder (\(folderName) was -> \(error)")
            }
        }
        
    }
    
    
    
    private func getUrlForFolder(folderName: String ) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getUrlForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
    
    func getImage(folderName: String , imageName: String) -> UIImage? {
        guard let url = getURLForImage(imageName: imageName, folderName: folderName) , FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
//        Gets the Image from the Folder, only of it exists there
        return UIImage(contentsOfFile: url.path)
    }
}
