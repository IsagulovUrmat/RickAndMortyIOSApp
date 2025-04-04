//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by sunflow on 31/3/25.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func searchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
    func searchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation)
    
    func searchView(_ searchView: RMSearchView, didSelectCharacter character: RMCharacter)
    
    func searchView(_ searchView: RMSearchView, didSelectEpisode episode: RMEpisode)
}
final class RMSearchView: UIView {
    
    weak var delegate: RMSearchViewDelegate?
    
    private let viewModel: RMSearchViewViewModel
    
    // MARK: - Subviews
     
    private let noResultsView = RMNoSearchResultsView()
    private let searchInputView = RMSearchInputView()
    private let resultsView = RMSearchResultsView()
    
    // MARK: - Init
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(resultsView ,noResultsView, searchInputView)
        addConstraints()
        
        searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        
        setupHandlers(viewModel: viewModel)
        
        resultsView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHandlers(viewModel: RMSearchViewViewModel) {
        viewModel.registerOptionChangeBlock { [weak self] tuple in
            self?.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        
        viewModel.registerSearchResultHandler { [weak self] result in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: result)
                self?.noResultsView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }
        
        viewModel.registerNoResultsHandler { [weak self]  in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            // Searh input view
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
            
            // results view
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // No results
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
}

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - RMSearchInputViewDelegate
extension RMSearchView: RMSearchInputViewDelegate {
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.searchView(self, didSelectOption: option)
    }
    
    func didSearchInputView(_ inputView: RMSearchInputView, didChangeSearchtext text: String) {
        viewModel.set(query: text)
    }
    
    func didSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
    
}

// MARK: - RMSearchResultsViewDelegate
extension RMSearchView: RMSearchResultsViewDelegate {
    func rmSearchResultsView(_ view: RMSearchResultsView, didTapLocationAt index: Int) {
        guard let locationModel = viewModel.locationSearchResults(at: index) else { return }
        delegate?.searchView(self, didSelectLocation: locationModel)
    }
    
    func rmSearchResultsView(_ view: RMSearchResultsView, didTapEpisodeAt index: Int) {
        guard let episodeModel = viewModel.episodeSearchResult(at: index) else { return }
        delegate?.searchView(self, didSelectEpisode: episodeModel)
    }
    
    func rmSearchResultsView(_ view: RMSearchResultsView, didTapCharacterAt index: Int) {
        guard let characterModel = viewModel.characterSearchResults(at: index) else { return }
        delegate?.searchView(self, didSelectCharacter: characterModel)
    }
    
}
