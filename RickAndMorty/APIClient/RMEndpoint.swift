//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by sunflow on 19/3/25.
//

import Foundation


/// Represents unique API endpoints
@frozen enum RMEndpoint: String, CaseIterable, Hashable {
    /// Endpoint to get character info
    case character
    /// Endpoint to get location info
    case location
    /// Endpoint to get episode info
    case episode
}
