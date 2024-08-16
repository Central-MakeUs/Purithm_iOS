//
//  FilterDetailReviewListViewController.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import UIKit
import CoreUIKit
import Combine

final class FilterDetailReviewListViewController: ViewController<FilterDetailReviewListView> {
    private let viewModel: FilterDetailReviewListViewModel
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: FilterDetailReviewListViewModel) {
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
        let input = FilterDetailReviewListViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        viewModel.willMoveItemIndexPath
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                self?.contentView.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            }
            .store(in: &cancellables)
    }
}

extension FilterDetailReviewListViewController: NavigationBarApplicable {
    var leftButtonItems: [NavigationBarButtonItemType] {
        return [
            .backImage(
                identifier: "left_back_bar_button",
                image: .icArrowLeft,
                color: .gray500
            )
        ]
    }
}
