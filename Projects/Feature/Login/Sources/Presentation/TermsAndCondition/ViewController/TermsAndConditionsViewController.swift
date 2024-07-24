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

final class TermsAndConditionsViewController: ViewController<TermsAndConditionsView> {
    let viewModel: TermsAndConditionsViewModel
    private var cancellables = Set<AnyCancellable>()
    
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
        case "back":
            break
        default:
            break
        }
    }
    
    public var leftButtonItems: [NavigationBarButtonItemType] {
        return [.backImage(
            identifier: "back",
            image: .icArrowLeft,
            color: .gray500
        )]
    }
}
