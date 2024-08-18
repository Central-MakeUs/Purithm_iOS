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
    private let viewModel: FilterDescriptionViewModel
    
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: FilterDescriptionViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar(with: .page, hideShadow: true)
        initNavigationTitleView(with: .page, title: "필터 소개")
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = FilterDescriptionViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher()
        )
        
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
