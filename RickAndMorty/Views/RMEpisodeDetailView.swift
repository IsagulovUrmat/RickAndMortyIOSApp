//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by sunflow on 23/3/25.
//

import UIKit

final class RMEpisodeDetailView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
