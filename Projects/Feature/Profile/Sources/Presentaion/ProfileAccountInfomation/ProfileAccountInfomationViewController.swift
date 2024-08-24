//
//  ProfileAccountInfomationViewController.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import UIKit
import CoreUIKit
import Combine

final class ProfileAccountInfomationViewController: ViewController<ProfileAccountInfomationView> {
    private let viewModel: ProfileAccountInfomationViewModel
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ProfileAccountInfomationViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar(hideShadow: true)
        initNavigationTitleView(title: "계정 정보")
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = ProfileAccountInfomationViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
    }
}

extension ProfileAccountInfomationViewController: NavigationBarApplicable {
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

