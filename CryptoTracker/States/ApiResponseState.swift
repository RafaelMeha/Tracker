//
//  ApiResponseState.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/25/22.
//

import Foundation



enum ApiResponseState {
    case loading
    case success(contents: Any)
    case failed(error: Error)
}
