//
//  TermsAndConditionsViewController.swift
//  Login
//
//  Created by 이숭인 on 7/17/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import CoreUIKit
import CoreCommonKit

import Combine
import CombineCocoa

extension TermsAndConditionsViewController {
    enum Constants {
        static let leftBackBarButtonIdentifier = "left_back_bar_button"
    }
}

final class TermsAndConditionsViewController: ViewController<TermsAndConditionsView> {
    let viewModel: TermsAndConditionsViewModel
    var cancellables = Set<AnyCancellable>()
    
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    init(viewModel: TermsAndConditionsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray100
        
        bindViewModel()
        bindErrorHandler()
        
        initNavigationBar(with: .page, hideShadow: true)
        initNavigationTitleView(with: .page, title: "이용약관")
    }
    
    private func bindViewModel() {
        let input = TermsAndConditionsViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher(),
            termsItemDidTapEvent: adapter.didSelectItemPublisher,
            navigateTermsOfServiceEvent: adapter.actionEventPublisher,
            endOfAgreeEvent: contentView.agreeButton.tapPublisher
        )
        
        
        let output = viewModel.transform(input: input)
        
        output.sectionItems
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        output.canProceed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] canProceed in
                self?.contentView.updateButtonState(with: canProceed)
            }
            .store(in: &cancellables)
    }
}

extension TermsAndConditionsViewController: NavigationBarApplicable {
    public func handleNavigationButtonAction(with identifier: String) {
        switch identifier {
        case Constants.leftBackBarButtonIdentifier:
            //TODO: Alert 띄우기
            let alert = PurithmAlert(
                with: .withTwoButton(
                    title: "정말 가입을 중단할까요?",
                    conformTitle: "중단하기",
                    cancelTitle: "취소"
                )
            )
            
            alert.conformTapEventPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    alert.hide()
                    self?.closeViewController(animated: true)
                }
                .store(in: &cancellables)
            
            alert.cancelTapEventPublisher
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    alert.hide()
                }
                .store(in: &cancellables)
            
            alert.show(animated: false)
        default:
            break
        }
    }
    
    public var leftButtonItems: [NavigationBarButtonItemType] {
        return [.image(
            identifier: Constants.leftBackBarButtonIdentifier,
            image: .icArrowLeft,
            color: .gray500
        )]
    }
}

extension TermsAndConditionsViewController: PurithmErrorHandlerable {
    var errorPublisher: AnyPublisher<Error, Never> {
        viewModel.errorPublisher
    }
}
