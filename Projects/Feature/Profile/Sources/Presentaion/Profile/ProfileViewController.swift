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
        
        viewModel.presentHelpSheetPublisher
            .sink { [weak self] _ in
                self?.presentContentBottomSheet()
            }
            .store(in: &cancellables)
    }
}

extension ProfileViewController {
    private func presentContentBottomSheet() {
        let bottomSheetVC = PurithmContentBottomSheet()
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return bottomSheetVC.preferredContentSize.height
            })]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16.0
        }
        
        bottomSheetVC.contentModel = PurithmContentModel(
            contentType: .premiumFilterLock,
            title: "스탬프는 어떻게 모으나요?",
            description: "필터를 사용해보고 후기를 남기면 스탬프가 찍히고,\n일정 개수를 모으면 프리미엄 필터를 열람할 수 있어요."
        )
        
        self.present(bottomSheetVC, animated: true, completion: nil)
    }
}

extension ProfileViewController: NavigationBarApplicable {
    func handleNavigationButtonAction(with identifier: String) {
        switch identifier {
        case "setting_button":
            viewModel.profileSettingMoveEvent.send(())
        default:
            break
        }
    }
    
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
