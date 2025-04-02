//
//  RMSearchResultsViewViewModel.swift
//  RickAndMorty
//
//  Created by sunflow on 2/4/25.
//

// part 47
import Foundation


enum RMSearchResultsViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
   
}
