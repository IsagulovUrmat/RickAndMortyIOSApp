//
//  ImageLoader.swift
//  RickAndMorty
//
//  Created by sunflow on 21/3/25.
//

import UIKit

final class RMImageLoader {
    static let shared = RMImageLoader()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init() {
        
    }
    
    /// Get image content with URL
    /// - Parameters:
    ///   - url: Source URL
    ///   - completion: Callback
    public func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) as? Data {
            completion(.success(data))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
