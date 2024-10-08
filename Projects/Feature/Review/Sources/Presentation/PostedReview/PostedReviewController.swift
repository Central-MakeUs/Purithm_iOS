//
//  PostedReviewController.swift
//  Review
//
//  Created by 이숭인 on 8/12/24.
//

import UIKit
import CoreUIKit
import Combine

final class PostedReviewController: ViewController<PostedReviewView> {
    let viewModel: PostedReviewViewModel
    private var cancellables = Set<AnyCancellable>()
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    init(viewModel: PostedReviewViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar(with: .page, hideShadow: true)
        initNavigationTitleView(with: .page, title: "남긴 후기")
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = PostedReviewViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher(),
            adapterActionEvent: adapter.actionEventPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        output.conformAlertPresentEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentCompletePopup()
            }
            .store(in: &cancellables)
    }
}

extension PostedReviewController {
    private func presentCompletePopup() {
        let alert = PurithmAlert(with:
                .withTwoButton(
                    title: "작성한 후기를 삭제할까요?",
                    conformTitle: "삭제하기",
                    cancelTitle: "취소"
                )
        )
        alert.conformTapEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                alert.hide()
                self?.viewModel.removeReview()
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

extension PostedReviewController: NavigationBarApplicable {
    func handleNavigationButtonAction(with identifier: String) {
        switch identifier {
        case "close_image":
            viewModel.closeViewController()
        default:
            break
        }
    }
    
    var leftButtonItems: [NavigationBarButtonItemType] {
        [
            .image(
                identifier: "close_image",
                image: .icCancel,
                color: .gray500
            )
        ]
    }
}
