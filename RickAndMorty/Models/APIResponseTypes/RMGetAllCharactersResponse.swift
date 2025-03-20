//
//  RMGetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by sunflow on 20/3/25.
//

import Foundation

struct RMGetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMCharacter]
}
