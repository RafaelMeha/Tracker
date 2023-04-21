//
//  UIApplicationExtension.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/26/22.
//

import Foundation
import SwiftUI








extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
