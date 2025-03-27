//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by sunflow on 19/3/25.
//

import SafariServices
import SwiftUI
import UIKit

/// Controller to show various app options and settings
final class RMSettingsViewController: UIViewController {

    
    private var settingsSwiftUIController: UIHostingController<RMSettingsView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Settings"
        addSwiftUIController()
    }
    
    private func addSwiftUIController() {
        let settingsSwiftUIController = UIHostingController(rootView: RMSettingsView(viewModel: RMSettingsViewViewModel(cellViwModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0) { [weak self] option in
                self?.handleTap(option: option)
            }
        }))))
        
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsSwiftUIController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        self.settingsSwiftUIController = settingsSwiftUIController
    }
    
    private func handleTap(option: RMSettingsOption) {
        guard Thread.current.isMainThread else { return }
        
        if let url = option.targetURL {
            // open website
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        } else if option == .rateApp {
            // show rating prompt
        }
    }

}
