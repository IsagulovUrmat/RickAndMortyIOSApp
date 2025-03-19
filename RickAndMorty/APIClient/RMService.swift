//
//  RMService.swift
//  RickAndMorty
//
//  Created by sunflow on 19/3/25.
//

import Foundation


/// Primary API service to get Rick and Morty data
final class RMService {
    /// Shared singleton instance
    static let shared = RMService()
    
    
    /// Privatized constructor
    private init() {
        
    }
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: Callback with data or error
    ///   - type: The type of object we expect to get back
    public func execute<T: Codable>(_ request: RMRequest,
                                    expecting type: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void
    ) {
        
    }
}
