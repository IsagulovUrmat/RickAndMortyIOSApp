//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by sunflow on 31/3/25.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
    func didSearchInputView(_ inputView: RMSearchInputView, didChangeSearchtext text: String)
    func didSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView)
}

/// View for top part of search screen with search bar
final class RMSearchInputView: UIView {

    weak var delegate: RMSearchInputViewDelegate?
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = "Search..."
        return search
    }()
    
    private var viewModel: RMSearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else { return }
            let options = viewModel.options
            createOptionSelectionView(options: options)
        }
    }
    
    private var stackView: UIStackView?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(searchBar)
        addConstraits()
        
        searchBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func addConstraits() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 58),
        ])
    }
    
    private func createOptionStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        stackView.alignment = .center
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        return stackView
    }
    
    private func createOptionSelectionView(options: [RMSearchInputViewViewModel.DynamicOption]) {
        
        let stackView = createOptionStackView()
        self.stackView = stackView
        
        for x in 0..<options.count {
            let option = options[x]
            let button = createButton(with: option, tag: x)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func createButton(with option: RMSearchInputViewViewModel.DynamicOption, tag: Int) -> UIButton {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(
            string: option.rawValue,
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                .foregroundColor: UIColor.label
            ]),
                                  for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.tag = tag
        button.layer.cornerRadius = 6
        
        return button
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        guard let options = viewModel?.options else { return }
        let tag = sender.tag
        let selected = options[tag]
        
        delegate?.rmSearchInputView(self, didSelectOption: selected)
    }
    
    // MARK: - Public
    public func configure(with viewModel: RMSearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceholderText
        self.viewModel = viewModel
    }
    
    public func presentKeyboard() {
        searchBar.becomeFirstResponder()
    }
    
    public func update(option: RMSearchInputViewViewModel.DynamicOption, value: String) {
        guard let buttons = stackView?.arrangedSubviews as? [UIButton],
              let allOptions = viewModel?.options,
              let index = allOptions.firstIndex(of: option) else { return }
        
        let button: UIButton = buttons[index]
        button.setAttributedTitle(NSAttributedString(
            string: value.uppercased(),
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                .foregroundColor: UIColor.link
            ]),
                                  for: .normal)
    }
}

// MARK: - UISearchBar delegate
extension RMSearchInputView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Notify delegate of change text
        delegate?.didSearchInputView(self, didChangeSearchtext: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Notify that search button was tapped
        searchBar.resignFirstResponder()
        delegate?.didSearchInputViewDidTapSearchKeyboardButton(self)
    }
}
