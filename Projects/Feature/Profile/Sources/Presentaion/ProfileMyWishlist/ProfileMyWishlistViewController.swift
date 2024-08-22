//
//  ProfileMyWishlistViewController.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import UIKit
import CoreUIKit
import Combine

final class ProfileMyWishlistViewController: ViewController<ProfileMyWishlistView> {
    private let viewModel: ProfileMyWishlistViewModel
    lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ProfileMyWishlistViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar(hideShadow: true)
        initNavigationTitleView(title: "찜 목록")
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = ProfileMyWishlistViewModel.Input(
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
        
        output.presentFilterRockBottomSheetEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentContentBottomSheet()
            }
            .store(in: &cancellables)
    }
}

//MARK: - Alert
extension ProfileMyWishlistViewController {
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
            title: "잠금은 어떻게 푸나요?",
            description: "필터를 사용해보고 후기를 남기면 스탬프가 찍히고,\n일정 개수를 모으면 프리미엄 필터를 열람할 수 있어요."
        )
        
        self.present(bottomSheetVC, animated: true, completion: nil)
    }
}

//MARK: - Navigation
extension ProfileMyWishlistViewController: NavigationBarApplicable {
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
