//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by sunflow on 22/3/25.
//

import Foundation

class RMCharacterPhotoCollectionViewCellViewModel {
    
    private let imageURL: URL?
    
    init(imageURL: URL?) {
        self.imageURL = imageURL
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageURL = imageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downloadImage(imageURL, completion: completion)
    }
}
