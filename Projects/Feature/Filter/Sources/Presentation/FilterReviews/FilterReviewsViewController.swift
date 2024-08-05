//
//  FilterReviewsViewController.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import UIKit
import CoreUIKit
import Combine

extension FilterReviewsViewController {
    private enum Constants {
        static let backImageIdentifier = "left_back_bar_button"
        static let questionImageIdentifier = "right_question_bar_button"
    }
}

final class FilterReviewsViewController: ViewController<FilterReviewsView> {
    private let viewModel: FilterReviewsViewModel
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: FilterReviewsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar(with: .page, hideShadow: true)
        initNavigationTitleView(with: .page)
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = FilterReviewsViewModel.Input(
            itemSelectEvent: adapter.didSelectItemPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
    }
}

extension FilterReviewsViewController: NavigationBarApplicable {
    func handleNavigationButtonAction(with identifier: String) {
        switch identifier {
        case Constants.questionImageIdentifier:
            print("::: 만족도 안내 바텀시트 올려야함")
        default:
            break
        }
    }
    
    var leftButtonItems: [NavigationBarButtonItemType] {
        return [
            .backImage(
                identifier: Constants.backImageIdentifier,
                image: .icArrowLeft,
                color: .gray500
            )
        ]
    }
    
    var rightButtonItems: [NavigationBarButtonItemType] {
        return [
            .image(
                identifier: Constants.questionImageIdentifier,
                image: .icQuestion,
                color: .gray500
            )
        ]
    }
}
