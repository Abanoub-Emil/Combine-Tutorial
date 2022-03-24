//
//  NetworkManager.swift
//  Combine Tutorial
//
//  Created by Abanoub Emil on 26/02/2022.
//

import Foundation
import Combine

class NetworkManager {
    
    static let shared = NetworkManager()
        
    func request<T: Codable>(_ url: URL, decodeTo: T.Type) -> AnyPublisher<T, CombineError>  {
        
        // create a publisher
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { CombineError.map($0) }
            .eraseToAnyPublisher()
    }
}

enum CombineError: Error {
  case statusCode
  case decoding
  case invalidImage
  case invalidURL
  case other(Error)
  
  static func map(_ error: Error) -> CombineError {
    return (error as? CombineError) ?? .other(error)
  }
}
