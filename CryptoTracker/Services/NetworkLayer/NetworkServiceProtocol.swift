//
//  NetworkServiceProtocol.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/25/22.
//

import Foundation
import Combine
typealias Headers = [String: Any]

protocol NetworkServiceProtocol: class {
    func get<T>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, ApiError>  where T: Decodable
}





