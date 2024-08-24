//
//  ProfileFilterAccessHistoryViewController.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import UIKit
import CoreUIKit
import Combine

final class ProfileFilterAccessHistoryViewController: ViewController<ProfileFilterAccessHistoryView> {
    private let viewModel: ProfileFilterAccessHistoryViewModel
    lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ProfileFilterAccessHistoryViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar(hideShadow: true)
        initNavigationTitleView(title: "필터 열람 내역")
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = ProfileFilterAccessHistoryViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher(),
            adapterActionEvent: adapter.actionEventPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        output.sectionEmptyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEmpty in
                self?.contentView.showEmptyViewIfNeeded(with: isEmpty)
            }
            .store(in: &cancellables)
    }
}

//MARK: - Navigation
extension ProfileFilterAccessHistoryViewController: NavigationBarApplicable {
    var leftButtonItems: [NavigationBarButtonItemType] {
        [
            .backImage(
                identifier: "back_button",
                image: .icArrowLeft,
                color: .gray500
            )
        ]
    }
}
