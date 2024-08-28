//
//  ProfileSettingViewController.swift
//  Profile
//
//  Created by 이숭인 on 8/19/24.
//

import UIKit
import CoreUIKit
import Combine

final class ProfileSettingViewController: ViewController<ProfileSettingView> {
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: ProfileSettingViewModel
    
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    init(viewModel: ProfileSettingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar(hideShadow: true)
        initNavigationTitleView(title: "설정")
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = ProfileSettingViewModel.Input(
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
        
        output.logoutEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentLogoutAlert()
            }
            .store(in: &cancellables)
        
        output.userTerminationEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentTerminationAlert()
            }
            .store(in: &cancellables)
    }
}

//MARK: - Alery
extension ProfileSettingViewController {
    private func presentLogoutAlert() {
        let alert = PurithmAlert(with:
                .withTwoButton(
                    title: "정말 로그아웃 할까요?",
                    conformTitle: "로그아웃",
                    cancelTitle: "취소"
                )
        )
        alert.conformTapEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                alert.hide()
                self?.viewModel.logoutEvent.send(Void())
            }
            .store(in: &cancellables)
        
        alert.cancelTapEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                alert.hide()
            }
            .store(in: &cancellables)
        
        
        alert.show(animated: false)
    }
    
    private func presentTerminationAlert() {
        let alert = PurithmAlert(with:
                .withTwoButton(
                    title: "정말 탈퇴할까요?",
                    content: "탈퇴하면 모든 회원 정보가 사라집니다.",
                    conformTitle: "탈퇴",
                    cancelTitle: "취소"
                )
        )
        alert.conformTapEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                alert.hide()
                self?.viewModel.requestAccountDeactive()
            }
            .store(in: &cancellables)
        
        alert.cancelTapEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                alert.hide()
            }
            .store(in: &cancellables)
        
        alert.show(animated: false)
    }
}


//MARK: - Navigation
extension ProfileSettingViewController: NavigationBarApplicable {
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
