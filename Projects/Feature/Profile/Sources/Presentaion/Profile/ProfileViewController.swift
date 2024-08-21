//
//  ProfileViewController.swift
//  Profile
//
//  Created by 이숭인 on 8/21/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

final class ProfileViewController: ViewController<ProfileView> {
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    private let viewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar()
        initNavigationTitleView()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = ProfileViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher(),
            didSelectItemEvent: adapter.didSelectItemPublisher,
            adapterActionEvent: adapter.actionEventPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
    }
}

extension ProfileViewController: NavigationBarApplicable {
    var rightButtonItems: [NavigationBarButtonItemType] {
        [
            .image(
                identifier: "setting_button",
                image: .icSettings,
                color: .gray500
            )
        ]
    }
}
