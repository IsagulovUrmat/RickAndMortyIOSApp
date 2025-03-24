//
//  RMGetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by sunflow on 24/3/25.
//

import Foundation

class RMGetAllEpisodesResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMEpisode]
}
