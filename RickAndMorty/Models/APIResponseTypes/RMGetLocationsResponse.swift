//
//  RMGetLocationsResponse.swift
//  RickAndMorty
//
//  Created by sunflow on 28/3/25.
//

import Foundation

class RMGetLocationsResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMLocation]
}
