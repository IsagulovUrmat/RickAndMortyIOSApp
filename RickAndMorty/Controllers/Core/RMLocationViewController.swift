//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by sunflow on 19/3/25.
//

import UIKit

/// Controller to show and search for locations
final class RMLocationViewController: UIViewController, RMLocationViewViewModelDelegate, RMLocationViewDelegate {
    
    // MARK: - Private properties
    private let primatyView = RMLocationView()
    private let viewModel = RMLocationViewViewModel()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(primatyView)
        primatyView.delegate = self
        view.backgroundColor = .systemBackground
        title = "Locations"
        
        addSearchButton()
        addConstraints()
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    // MARK: - Private Methods
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            primatyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primatyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            primatyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            primatyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func didTapSearch() {
        print("Search tapped")
    }
    
    // MARK: - RMLOcationView Delegate
    func didSelectLocation(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - ViewModel Delegate
    func didFetchInitialLocations() {
        primatyView.configure(with: viewModel)
    }
}
