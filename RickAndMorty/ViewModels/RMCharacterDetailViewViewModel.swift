//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by sunflow on 20/3/25.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var requestURL: URL? {
        return URL(string: character.url)
    }
    
    public var title: String {
        character.name.uppercased()
    }
    
   
}
