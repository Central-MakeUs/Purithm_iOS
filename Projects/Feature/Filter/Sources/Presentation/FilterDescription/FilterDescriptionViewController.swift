//
//  FilterDescriptionViewController.swift
//  Filter
//
//  Created by 이숭인 on 8/3/24.
//

import UIKit
import CoreUIKit
import Combine

extension FilterDescriptionViewController {
    private enum Constants {
        static let backImageIdentifier = "left_back_bar_button"
    }
}

final class FilterDescriptionViewController: ViewController<FilterDescriptionView> {
    private let viewModel = FilterDescriptionViewModel()
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar(with: .page, hideShadow: true)
        initNavigationTitleView(with: .page)
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = FilterDescriptionViewModel.Input()
        
        let output = viewModel.transform(from: input)
        
        output.descriptions
            .sink { [weak self] descriptions in
                self?.contentView.configure(with: descriptions)
            }
            .store(in: &cancellables)
    }
}

extension FilterDescriptionViewController: NavigationBarApplicable {
    var leftButtonItems: [NavigationBarButtonItemType] {
        return [
            .backImage(
                identifier: Constants.backImageIdentifier,
                image: .icArrowLeft,
                color: .gray500
            )
        ]
    }
}
