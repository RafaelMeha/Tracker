//
//  NetworkService.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/25/22.
//

import Foundation
import Combine


class NetworkService {
    enum NetworkingError: LocalizedError {
        case badUrlResponse(url: URL)
        case unknown
//
        
        
        var errorDescription: String? {
            switch self {
            case .badUrlResponse(url: let url): return "[🔥] Bad Response from URL: \(url)"
            case .unknown : return "[😩] An Unknown Error has occured."
                
            }
        }
    }
    static func get(url: URL)-> AnyPublisher<Data,Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap( { try handleUrlResponse(output: $0, url: url)})
            
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
//    Check s if we have a status code ranging from (200 to 299)
    static func handleUrlResponse (output: URLSession.DataTaskPublisher.Output, url: URL ) throws -> Data {
        
        guard let response = output.response as? HTTPURLResponse , (200...299).contains(response.statusCode) else {
            throw NetworkingError.badUrlResponse(url: url)
        }
        return output.data
    }
    static func handleCompletion (completion: Subscribers.Completion<Error> ) {
        switch completion {
        case .finished: break
        case .failure(let error ):
            print(error.localizedDescription)
        }
    }
    
    
    static func post(url: URL, headers: [String: String]? = nil , body: [String: String])-> AnyPublisher<Data, Error>  {
        var  urlRequest = URLRequest(url: url)
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
        urlRequest.httpMethod = "POST"
        urlRequest.timeoutInterval = TimeInterval(30)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse , (200...299).contains(response.statusCode) else {
                    print("Print Response == \(output.response)")
//                    let data = String(data: output.data, encoding: .utf8)
                    do{
                        let json = try JSONSerialization.jsonObject(with: output.data, options: []) as? [String : Any]
                                            print("Json Data From Server -> \(json) ")
                    }catch{ print("erroMsg") }
                    throw NetworkingError.badUrlResponse(url: url)

                }
//                let data = String(data: output.data, encoding: .utf8)
//                print("Data From Server -> \(data) ")
                do{
                  
                    let json = try JSONSerialization.jsonObject(with: output.data, options: []) as? [String : Any]
                    print("Json Data From Server  Success -> \(json) ")
                }catch{ print("erroMsg") }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
//            .tryMap({ try handleUrlResponse(output: $0, url: url)})
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
        
    }
}
