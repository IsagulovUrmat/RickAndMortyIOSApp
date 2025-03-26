//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by sunflow on 23/3/25.
//

import Foundation

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}
final class RMEpisodeDetailViewViewModel {
    
    // MARK: - Private properties
    private let endpointURL: URL?
    private var dataTuple: (RMEpisode, [RMCharacter])? {
        didSet {
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellVIewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    // MARK: - Delegate
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    public private(set) var section: [SectionType] = []
    
    
    // MARK: - Init
    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
    }
    
    // MARK: - Public methods
    
    /// Fetch backing episode model
    public func fetchEpisodeData() {
        guard let url = endpointURL, let request = RMRequest(url: url) else { return }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure:
                break
            }
        }
    }
    
    // MARK: - Private methods
    
  
    
    private func fetchRelatedCharacters(episode: RMEpisode) {
        let requests: [RMRequest] = episode.characters.compactMap({
            return URL(string: $0) // first creates collection of URLS
        }).compactMap({
            return RMRequest(url: $0) // and then creates collection of requests from urls
        })
        
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (
                episode,
                characters
            )
        }
    }
    
}
