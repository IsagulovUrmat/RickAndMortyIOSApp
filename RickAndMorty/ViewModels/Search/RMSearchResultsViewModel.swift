//
//  RMSearchResultsViewModel.swift
//  RickAndMorty
//
//  Created by sunflow on 2/4/25.
//

// part 47
import Foundation


final class RMSearchResultsViewModel {
    public private(set) var results: RMSearchResultsType
    private var next: String?
    
    init(results: RMSearchResultsType, next: String?) {
        self.results = results
        self.next = next
    }
    
    public private(set) var isLoadingMoreResults = false
    
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    public func fetchAdditionalLocations(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void) {
        guard !isLoadingMoreResults else { return }
        
        guard let nextURLString = next,
              let url = URL(string: nextURLString) else { return }
        
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return }
        
        RMService.shared.execute(request, expecting: RMGetLocationsResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                self.next = info.next // capture new pagination url
                
                let additionalLocations =  moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                })
                
                var newResults: [RMLocationTableViewCellViewModel] = []
                
                switch self.results {
                case .characters, .episodes:
                    break
                case .locations(let exisitingResults):
                    newResults = exisitingResults + additionalLocations
                    self.results = .locations(newResults)
                    break
                }
                
                DispatchQueue.main.async {
                    self.isLoadingMoreResults = false
                    
                    // Notify via callback
                    completion(newResults)
                }
            case .failure(let failure):
                print(String(describing: failure))
                self.isLoadingMoreResults = false
            }
        }
    }
}

enum RMSearchResultsType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
   
}
