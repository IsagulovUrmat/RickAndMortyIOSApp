//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by sunflow on 22/3/25.
//

import Foundation

class RMCharacterInfoCollectionViewCellViewModel {
    
    public let value: String
    public let title: String
    
    
    init(value: String, title: String) {
        self.value = value
        self.title = title
    }
}
