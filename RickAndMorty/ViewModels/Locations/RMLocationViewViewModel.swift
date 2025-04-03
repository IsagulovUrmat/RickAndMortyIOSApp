//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by sunflow on 28/3/25.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}
final class RMLocationViewViewModel {
    
    weak var delegate: RMLocationViewViewModelDelegate?
    
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    private var apiInfo: RMGetLocationsResponse.Info?
    
    private var didFinishPagination: (() -> Void)?
    
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    public var isLoadingMoreLocation = false
    
    
    // MARK: - Init
    init() {
        
    }
    
    public func registerDidFinishPaginationBLock(_ block: @escaping () -> Void) {
        self.didFinishPagination = block
    }
    
    /// Paginate if additional locations  are needed
    public func fetchAdditionalLocations() {
        guard !isLoadingMoreLocation else { return }
        
        guard let nextURLString = apiInfo?.next,
              let url = URL(string: nextURLString) else { return }
        
        isLoadingMoreLocation = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreLocation = false
            return }
        
        RMService.shared.execute(request, expecting: RMGetLocationsResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                self.apiInfo = info
                self.cellViewModels.append(contentsOf: moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                }))
                
                DispatchQueue.main.async {
                    self.isLoadingMoreLocation = false
                    
                    // Notify via callback
                    self.didFinishPagination?()
                }
            case .failure(let failure):
                print(String(describing: failure))
                self.isLoadingMoreLocation = false
            }
        }
    }
    
    public func location(at index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else { return nil }
        
        return self.locations[index]
    }
    
    public func fetchLocations() {
        RMService.shared.execute(.listLocationsRequest, expecting: RMGetLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let failure):
                break
            }
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
