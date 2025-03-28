//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by sunflow on 19/3/25.
//

import UIKit

/// Controller to show and search for locations
final class RMLocationViewController: UIViewController {

    // MARK: - Private properties
    private let primatyView = RMLocationView()
    private let viewModel = RMLocationViewViewModel()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(primatyView)
        view.backgroundColor = .systemBackground
        title = "Locations"
        
        addSearchButton()
        addConstraints()
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
}
