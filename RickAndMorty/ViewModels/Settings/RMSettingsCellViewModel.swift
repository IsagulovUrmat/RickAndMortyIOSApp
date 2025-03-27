//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by sunflow on 27/3/25.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable, Hashable {
    
    let id = UUID()
    
    
    private let type: RMSettingsOption
    
    
    // MARK: - Init
    init(type: RMSettingsOption) {
        self.type = type
    }
    
    // MARK: - Public Properties
    
    public var image: UIImage? {
        type.iconImage
    }
    
    public var title: String {
        type.displayTitle
    }
    
    public var iconContainerColor: UIColor {
        type.iconContainerColor
    }
       
}
