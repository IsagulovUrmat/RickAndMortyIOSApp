//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by sunflow on 31/3/25.
//

import Foundation

class RMSearchViewViewModel {
    
    let config: RMSearchViewController.Config
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var searcText = ""
    
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    
    private var searchResultsHandler: ((RMSearchResultsViewModel) -> Void)?
    private var noResultsHandler: (() -> Void)?
    private var searchREsultsModel: Codable?
    
    // MARK: - Init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Public
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultsViewModel) -> Void) {
        self.searchResultsHandler = block
    }
    
    public func registerNoResultsHandler(_ block: @escaping () -> Void) {
        self.noResultsHandler = block
    }
    
    public func executeSearch() {
        guard !searcText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        // Build arguments
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searcText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        
        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key: RMSearchInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        
        // Create request
        let request = RMRequest(endpoint: config.type.endpoint, queryParameters: queryParams)
        
        switch config.type.endpoint {
        case .character:
            makeSearchAPIcall(RMGetAllCharactersResponse.self, request: request)
        case .location:
            makeSearchAPIcall(RMGetLocationsResponse.self, request: request)
        case .episode:
            makeSearchAPIcall(RMGetAllEpisodesResponse.self, request: request)
        }
        
    }
    
    private func makeSearchAPIcall<T: Codable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(request, expecting: type) { [weak self] result in
            switch result {
            case .success(let model):
                self?.processSearchResults(model: model)
            case .failure:
                self?.handleNoResults()
                break
            }
        }
    }
    
    private func processSearchResults(model: Codable) {
        var resultsVM: RMSearchResultsType?
        var nextUrl: String?
        if let characterResults = model as? RMGetAllCharactersResponse {
            resultsVM = .characters(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageURL: URL(string: $0.image))
            }))
            nextUrl = characterResults.info.next
        } else if let locationResults = model as? RMGetLocationsResponse {
            resultsVM = .locations(locationResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
            nextUrl = locationResults.info.next
        }  else if let episodeResults = model as? RMGetAllEpisodesResponse {
            resultsVM = .episodes(episodeResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataURL: URL(string: $0.url))
            }))
            nextUrl = episodeResults.info.next
        }
        
        if let results = resultsVM {
            self.searchREsultsModel = model
            let vm = RMSearchResultsViewModel(results: results, next: nextUrl)
            self.searchResultsHandler?(vm)
        } else {
            // fallback error
            handleNoResults()
        }
    }
    
    private func handleNoResults() {
        noResultsHandler?()
    }
    
    public func set(query text: String) {
        self.searcText = text
    }
    
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func registerOptionChangeBlock(_ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void) {
        self.optionMapUpdateBlock = block
    }
    
    public func locationSearchResults(at index: Int) -> RMLocation? {
        guard let searchModel = searchREsultsModel as? RMGetLocationsResponse else { return nil }
        
        return searchModel.results[index]
    }
    
    public func characterSearchResults(at index: Int) -> RMCharacter? {
        guard let searchModel = searchREsultsModel as? RMGetAllCharactersResponse else { return nil }
        
        return searchModel.results[index]
    }
    
    public func episodeSearchResult(at index: Int) -> RMEpisode? {
        guard let searchModel = searchREsultsModel as? RMGetAllEpisodesResponse else { return nil }
        
        return searchModel.results[index]
    }
    
}
