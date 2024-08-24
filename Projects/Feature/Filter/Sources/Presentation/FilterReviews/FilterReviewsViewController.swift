//
//  FilterReviewsViewController.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import UIKit
import CoreUIKit
import Combine

extension FilterReviewsViewController {
    private enum Constants {
        static let backImageIdentifier = "left_back_bar_button"
        static let questionImageIdentifier = "right_question_bar_button"
    }
}

final class FilterReviewsViewController: ViewController<FilterReviewsView> {
    private let viewModel: FilterReviewsViewModel
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: FilterReviewsViewModel) {
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
        let input = FilterReviewsViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher(),
            itemSelectEvent: adapter.didSelectItemPublisher,
            conformTapEvent: contentView.conformTapEvent
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        output.filterRecordForMePublisher
            .sink { [weak self] recordModel in
                self?.contentView.updateConformButton(with: recordModel)
            }
            .store(in: &cancellables)
    }
}

extension FilterReviewsViewController: NavigationBarApplicable {
    func handleNavigationButtonAction(with identifier: String) {
        switch identifier {
        case Constants.questionImageIdentifier:
            presentContentBottomSheet()
        default:
            break
        }
    }
    
    var leftButtonItems: [NavigationBarButtonItemType] {
        return [
            .backImage(
                identifier: Constants.backImageIdentifier,
                image: .icArrowLeft,
                color: .gray500
            )
        ]
    }
    
    var rightButtonItems: [NavigationBarButtonItemType] {
        return [
            .image(
                identifier: Constants.questionImageIdentifier,
                image: .icQuestion,
                color: .gray500
            )
        ]
    }
}

//MARK: - Present Bottom Sheet
extension FilterReviewsViewController {
    private func presentContentBottomSheet() {
        let bottomSheetVC = PurithmContentBottomSheet()
        bottomSheetVC.contentModel = PurithmContentModel(
            contentType: .satisfaction,
            title: "필터 만족도",
            description: "퓨어지수는 퓨리즘만의 별점 시스템입니다. 구매 만족도가 높을수록 100%에 가까워요."
        )
        
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return bottomSheetVC.preferredContentSize.height
            })]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16.0
        }
        
        self.present(bottomSheetVC, animated: true, completion: nil)
    }
}
